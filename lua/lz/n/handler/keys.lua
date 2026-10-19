local loader = require("lz.n.loader")

---@class lz.n.KeysHandler: lz.n.Handler

---@param value lz.n.KeysSpec
---@param mode? string
---@return lz.n.Keys
local function parse_keys_spec(value, mode)
    local ret = vim.deepcopy(value) --[[@as lz.n.Keys]]
    ret.lhs = ret[1] or ""
    ret.rhs = ret[2]
    ret[1] = nil
    ret[2] = nil
    ret.mode = mode or "n"
    ret.id = vim.api.nvim_replace_termcodes(ret.lhs, true, true, true)
    if ret.ft then
        local ft = type(ret.ft) == "string" and { ret.ft } or ret.ft --[[@as string[] ]]
        ret.id = ret.id .. " (" .. table.concat(ft, ", ") .. ")"
    end
    if ret.mode ~= "n" then
        ret.id = ret.id .. " (" .. ret.mode .. ")"
    end
    return ret
end

---@param keys lz.n.Keys
local function is_nop(keys)
    return type(keys.rhs) == "string" and (keys.rhs == "" or keys.rhs:lower() == "<nop>")
end

---@param value string|lz.n.KeysSpec
---@return lz.n.Keys[]
local function parse(value)
    value = type(value) == "string" and { value } or value --[[@as lz.n.KeysSpec]]
    local modes = type(value.mode) == "string" and { value.mode } or value.mode --[[ @as string[] | nil ]]
    if not modes then
        return { parse_keys_spec(value) }
    end
    return vim
        .iter(modes)
        ---@param mode string
        :map(function(mode)
            ---@diagnostic disable-next-line: missing-return-value
            return parse_keys_spec(value, mode)
        end)
        :totable()
end

---@type lz.n.handler.State
local state = require("lz.n.handler.state").new()

---@type lz.n.KeysHandler
---@diagnostic disable-next-line: missing-fields
local M = {
    spec_field = "keys",
    ---@param keys_spec? string|string[]|lz.n.KeysSpec[]
    parse = function(plugin, keys_spec)
        if keys_spec then
            plugin.keys = {}
        end
        if type(keys_spec) == "string" then
            local keys = parse(keys_spec)
            vim.list_extend(plugin.keys, keys)
        elseif type(keys_spec) == "table" then
            ---@param keys_spec_ string | lz.n.KeysSpec
            vim.iter(keys_spec):each(function(keys_spec_)
                local keys = parse(keys_spec_)
                vim.list_extend(plugin.keys, keys)
            end)
        end
    end,
}

---@param name string
---@return lz.n.Plugin?
function M.lookup(name)
    return state.lookup_plugin(name)
end

local skip = { mode = true, id = true, ft = true, rhs = true, lhs = true }

---@param keys lz.n.Keys
---@return lz.n.KeysBase
local function get_opts(keys)
    ---@type lz.n.KeysBase
    return vim.iter(keys):fold({}, function(acc, k, v)
        if type(k) ~= "number" and not skip[k] then
            acc[k] = v
        end
        return acc
    end)
end

-- Create a mapping if it is managed by lz.n
---@param keys lz.n.Keys
---@param buf integer?
local function set(keys, buf)
    if keys.rhs then
        local opts = get_opts(keys)
        ---@diagnostic disable-next-line: inject-field
        opts.buffer = buf
        vim.keymap.set(keys.mode, keys.lhs, keys.rhs, opts)
    end
end

-- Delete a mapping and create the real global
-- mapping when needed
---@param keys lz.n.Keys
local function del(keys)
    pcall(vim.keymap.del, keys.mode, keys.lhs, {
        -- NOTE: for buffer-local mappings, we only delete the mapping for the current buffer
        -- So the mapping could still exist in other buffers
        buffer = keys.ft and true or nil,
    })
end

---@param keys lz.n.Keys
local function add_keys(keys)
    local lhs = keys.lhs
    local opts = get_opts(keys)

    ---@param buf? number
    local function add(buf)
        if is_nop(keys) then
            return set(keys, buf)
        end
        vim.keymap.set(keys.mode, lhs, function()
            -- always delete the mapping immediately to prevent recursive mappings
            del(keys)
            -- make sure to create global mappings when needed
            -- buffer-local mappings are managed by lz.n
            if not keys.ft then
                set(keys)
            end
            state.each_pending(keys.id, loader.load)
            -- Create the real buffer-local mapping
            if keys.ft then
                set(keys, buf)
            end
            if keys.mode:sub(-1) == "a" then
                lhs = lhs .. "<C-]>"
            end
            local feed = vim.api.nvim_replace_termcodes("<Ignore>" .. lhs, true, true, true)
            -- insert instead of append the lhs
            vim.api.nvim_feedkeys(feed, "i", false)
        end, {
            desc = opts.desc,
            nowait = opts.nowait,
            -- we do not return anything, but this is still needed to make operator pending mappings work
            expr = true,
            buffer = buf,
        })
    end
    -- buffer-local mappings
    if keys.ft then
        vim.api.nvim_create_autocmd("FileType", {
            pattern = keys.ft,
            nested = true,
            callback = function(event)
                if state.has_pending_plugins(keys.id) then
                    add(event.buf)
                else
                    -- Only create the mapping if its managed by lz.n
                    -- otherwise the plugin is supposed to manage it
                    set(keys, event.buf)
                end
            end,
        })
    else
        add()
    end
end

---@param plugin lz.n.Plugin
function M.add(plugin)
    ---@param key lz.n.Keys
    vim.iter(plugin.keys or {}):each(function(key)
        state.insert(key.id, plugin)
        add_keys(key)
    end)
end

M.del = state.del

return M
