---@mod lz.n.handler.state Safe state management for handlers
---
---@brief [[
---This module is to be used by |lz.n.Handler| implementations.
---It provides an API for safely managing handler state,
---ensuring that `trigger_load` can be called in plugin hooks.
---@brief ]]

local state = {}

---@return lz.n.handler.State
function state.new()
    ---@type table<string, table<string, lz.n.Plugin>>
    local pending = {}

    ---@type lz.n.handler.State
    return {
        insert = function(key, plugin)
            pending[key] = pending[key] or {}
            pending[key][plugin.name] = plugin
        end,

        del = function(plugin_name, callback)
            vim.iter(pending)
                :filter(function(_, plugins)
                    return plugins[plugin_name] ~= nil
                end)
                :each(
                    ---@param key string
                    ---@param plugins lz.n.Plugin[]
                    function(key, plugins)
                        if callback then
                            callback(key)
                        end
                        plugins[plugin_name] = nil
                    end
                )
        end,

        has_pending_plugins = function(key)
            return pending[key] ~= nil and not vim.tbl_isempty(pending[key])
        end,

        lookup_plugin = function(plugin_name)
            return vim
                .iter(pending)
                ---@param plugins table<string, lz.n.Plugin>
                :map(function(_, plugins)
                    return plugins[plugin_name]
                end)
                ---@param plugin lz.n.Plugin?
                :find(function(plugin)
                    return plugin ~= nil
                end)
        end,

        each_pending = function(key, callback)
            local plugins = pending[key] or {}
            vim
                .iter(vim.deepcopy(plugins))
                ---@param plugin lz.n.Plugin
                :each(function(_, plugin)
                    if pending[key][plugin.name] then
                        callback(plugin)
                    end
                end)
            return vim.tbl_keys(plugins)
        end,
    }
end

---@class lz.n.handler.State
---
---Insert a plugin by key.
---@field insert fun(key: string, plugin: lz.n.Plugin)
---
---Remove a plugin by its name.
---@field del fun(plugin_name: string, callback?: fun(key: string))
---
---Check if there are pending plugins for a key
---@field has_pending_plugins fun(key: string):boolean
---
---Lookup a plugin by its name.
---@field lookup_plugin fun(plugin_name: string):lz.n.Plugin?
---
---Safely apply a callback to all pending plugins by key.
---@field each_pending fun(key: string, callback: fun(plugin: lz.n.Plugin)): string[]

return state
