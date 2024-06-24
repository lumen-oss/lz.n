local M = {}

local handlers = {
    cmd = require("lz.n.handler.cmd"),
    event = require("lz.n.handler.event"),
    ft = require("lz.n.handler.ft"),
    keys = require("lz.n.handler.keys"),
    colorscheme = require("lz.n.handler.colorscheme"),
}

---@param spec lz.n.PluginSpec
---@return boolean
function M.is_lazy(spec)
    ---@diagnostic disable-next-line: undefined-field
    return spec.lazy or vim.iter(handlers):any(function(spec_field, _)
        return spec[spec_field] ~= nil
    end)
end

---@param handler lz.n.Handler
---@return boolean success
function M.register_handler(handler)
    if handlers[handler.spec_field] == nil then
        handlers[handler.spec_field] = handler
        return true
    else
        vim.notify(
            "Handler already exists for " .. handler.spec_field .. ". Refusing to register new handler.",
            vim.log.levels.ERROR,
            { title = "lz.n" }
        )
        return false
    end
end

---@param plugin lz.n.Plugin
local function enable(plugin)
    for _, handler in pairs(handlers) do
        handler.add(plugin)
    end
end

function M.disable(plugin)
    for _, handler in pairs(handlers) do
        if handler.del then
            handler.del(plugin)
        end
    end
end

---@param plugins table<string, lz.n.Plugin>
function M.init(plugins)
    for _, plugin in pairs(plugins) do
        xpcall(
            enable,
            vim.schedule_wrap(function(err)
                vim.notify(("Failed to enable handlers for %s: %s"):format(plugin.name, err), vim.log.levels.ERROR)
            end),
            plugin
        )
    end
end

return M
