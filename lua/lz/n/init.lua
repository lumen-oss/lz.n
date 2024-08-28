---@mod lz.n
---
---@brief [[
---A dead simple lazy-loading Lua library for Neovim plugins.
---
---It is intended to be used
---
---- by users of plugin managers that don't provide a convenient API for lazy-loading.
---- by plugin managers, to provide a convenient API for lazy-loading.
---@brief ]]

---@toc lz.n.contents

---@mod lz.n.api lz.n Lua API

local M = {}

if vim.fn.has("nvim-0.10.0") ~= 1 then
    error("lz.n requires Neovim >= 0.10.0")
end

local deferred_ui_enter = vim.schedule_wrap(function()
    if vim.v.exiting ~= vim.NIL then
        return
    end
    vim.g.lz_n_did_deferred_ui_enter = true
    vim.api.nvim_exec_autocmds("User", { pattern = "DeferredUIEnter", modeline = false })
end)

--- The function provides two overloads, each suited for different use cases:
---
---@overload fun(plugin: lz.n.Plugin)
--- **Stateless version:**
---   - Intended for: Use by a `lz.n.Handler`
---   - Description: This version should be used when working with `lz.n.Handler`
---     instances to maintain referential transparency.
---     Each handler has full authority over its internal state, ensuring it
---     remains isolated and unaffected by external influences,
---     thereby preventing multiple sources of truth.
---   - Note: If loading multiple plugins simultaneously,
---     handlers should iterate over |vim.deepcopy| of the plugins,
---     verifying they are still pending before each `trigger_load` call.
---     This practice allows for safe invocation of the stateful `trigger_load`
---     in `before` and `after` hooks.
---
---@overload fun(plugins: string | string[], opts?: lz.n.lookup.Opts): string[]
--- **Stateful version:**
---   - Returns: A list of plugin names that were skipped
---     (empty if all plugins were loaded).
---   - Intended for: Scenarios where handler state is unknown or inaccessible,
---     such as in `before` or `after` hooks.
---   - Description: This version allows you to load plugins by name.
---     It searches through the handlers, querying their `lookup` functions
---     to identify an appropriate plugin, and returns the first match.
---     You can fine-tune the search process by providing a [`lz.n.lookup.Opts` table](#lookup).
M.trigger_load = function(plugins, opts)
    return require("lz.n.loader").load(plugins, function(name)
        return M.lookup(name, opts)
    end)
end

---@overload fun(spec: lz.n.Spec)
---Register a list with your plugin specs or a single plugin spec to be lazy-loaded.
---
---@overload fun(import: string)
---Register a Lua module name that contains your plugin spec(s) to be lazy-loaded.
function M.load(spec)
    if type(spec) == "string" then
        spec = { import = spec }
    end
    --- @cast spec lz.n.Spec
    local spec_mod = require("lz.n.spec")
    local plugins = spec_mod.parse(spec)

    -- calls handler add functions
    require("lz.n.handler").init(plugins)

    -- Because this calls the handlers' `del` functions,
    -- this should be ran after the plugins are registered with the handlers.
    -- even if an eager plugin isn't supposed to have been added to any of them
    -- This allows even startup plugins to call
    -- `require('lz.n').trigger_load()` safely
    require("lz.n.loader").load_startup_plugins(plugins)

    if vim.v.vim_did_enter == 1 then
        deferred_ui_enter()
    elseif not vim.g.lz_n_did_create_deferred_ui_enter_autocmd then
        vim.api.nvim_create_autocmd("UIEnter", {
            once = true,
            callback = deferred_ui_enter,
        })
        vim.g.lz_n_did_create_deferred_ui_enter_autocmd = true
    end
end

--- Lookup a plugin that is pending to be loaded by name.
---@param name string
---@param opts? lz.n.lookup.Opts
---@return lz.n.Plugin?
function M.lookup(name, opts)
    return require("lz.n.handler").lookup(name, opts)
end

---@class lz.n.lookup.Opts
---
--- The handlers to include in the search (filtered by `spec_field`)
--- In case of multiple filters, the order of the filter list
--- determines the order in which handlers' `lookup` functions are called.
---@field filter string | string[]

---Register a custom handler.
---@param handler lz.n.Handler
---@return boolean success
M.register_handler = function(handler)
    return require("lz.n.handler").register_handler(handler)
end

return M
