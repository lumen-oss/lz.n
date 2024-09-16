local event = require("lz.n.handler.event")

---@class lz.n.FtHandler: lz.n.Handler

---@param value string
---@return lz.n.Event
local function parse(value)
    return {
        id = value,
        event = "FileType",
        pattern = value,
    }
end

---@type lz.n.FtHandler
local M = {
    spec_field = "ft",
    lookup = event.lookup,
    ---@param ft_spec? string[]|string
    parse = function(plugin, ft_spec)
        if ft_spec then
            plugin.event = plugin.event or {}
            ---@diagnostic disable-next-line: inject-field
            plugin.ft = nil
        end
        if type(ft_spec) == "string" then
            local ft = parse(ft_spec)
            table.insert(plugin.event, ft)
        elseif type(ft_spec) == "table" then
            ---@param ft_spec_ string
            vim.iter(ft_spec):each(function(ft_spec_)
                local ft = parse(ft_spec_)
                table.insert(plugin.event, ft)
            end)
        end
    end,
}

---@param plugin lz.n.Plugin
function M.add(plugin)
    event.add(plugin)
end

---@param name string
function M.del(name)
    event.del(name)
end

return M
