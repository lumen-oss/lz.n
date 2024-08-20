local loader = require("lz.n.loader")

---@class lz.n.CmdHandler: lz.n.Handler

---@type table<string, table<string, lz.n.Plugin[]>>
local pending = {}

---@type lz.n.CmdHandler
local M = {
    spec_field = "cmd",
}

---@param name string
---@return lz.n.Plugin?
function M.lookup(name)
    return require("lz.n.handler.extra").lookup(pending, name)
end

---@param cmd string
local function load(cmd)
    vim.api.nvim_del_user_command(cmd)
    loader.load(vim.tbl_values(pending[cmd]))
end

---@param cmd string
local function add_cmd(cmd)
    vim.api.nvim_create_user_command(cmd, function(event)
        ---@cast event vim.api.keyset.user_command
        local command = {
            cmd = cmd,
            bang = event.bang or nil,
            ---@diagnostic disable-next-line: undefined-field
            mods = event.smods,
            ---@diagnostic disable-next-line: undefined-field
            args = event.fargs,
            count = event.count >= 0 and event.range == 0 and event.count or nil,
        }

        if event.range == 1 then
            ---@diagnostic disable-next-line: undefined-field
            command.range = { event.line1 }
        elseif event.range == 2 then
            ---@diagnostic disable-next-line: undefined-field
            command.range = { event.line1, event.line2 }
        end

        load(cmd)

        local info = vim.api.nvim_get_commands({})[cmd] or vim.api.nvim_buf_get_commands(0, {})[cmd]
        if not info then
            vim.schedule(function()
                ---@type string
                local plugins = "`" .. table.concat(vim.tbl_values(pending[cmd]), ", ") .. "`"
                vim.notify("Command `" .. cmd .. "` not found after loading " .. plugins, vim.log.levels.ERROR)
            end)
            return
        end

        command.nargs = info.nargs
        ---@diagnostic disable-next-line: undefined-field
        if event.args and event.args ~= "" and info.nargs and info.nargs:find("[1?]") then
            ---@diagnostic disable-next-line: undefined-field
            command.args = { event.args }
        end
        vim.cmd(command)
    end, {
        bang = true,
        range = true,
        nargs = "*",
        complete = function(_, line)
            load(cmd)
            return vim.fn.getcompletion(line, "cmdline")
        end,
    })
end

---@param name string
function M.del(name)
    vim.iter(pending)
        :filter(function(_, plugins)
            return plugins[name] ~= nil
        end)
        :each(function(cmd, plugins)
            pcall(vim.api.nvim_del_user_command, cmd)
            plugins[name] = nil
        end)
end

---@param plugin lz.n.Plugin
function M.add(plugin)
    if not plugin.cmd then
        return
    end
    ---@param cmd string
    vim.iter(plugin.cmd):each(function(cmd)
        pending[cmd] = pending[cmd] or {}
        pending[cmd][plugin.name] = plugin
        add_cmd(cmd)
    end)
end

return M
