local M = {}

---@param modname string
---@param result table<string, lz.n.Plugin>
local function import_modname(modname, result)
    local ok, mod = pcall(require, modname)
    if not ok then
        vim.schedule(function()
            local err = type(mod) == "string" and ": " .. mod or ""
            vim.notify("Failed to load module '" .. modname .. err, vim.log.levels.ERROR)
        end)
        return
    end
    if type(mod) ~= "table" then
        vim.schedule(function()
            vim.notify(
                "Invalid plugin spec module '" .. modname .. "' of type '" .. type(mod) .. "'",
                vim.log.levels.ERROR
            )
        end)
        return
    end
    M._normalize(mod, result)
end

---@param modname string module name in the format `foo.bar`
---@return string modpath module path in the format `foo/bar`
local function mod_name_to_path(modname)
    return vim.fs.joinpath(unpack(vim.split(modname, ".", { plain = true })))
end

---@param spec lz.n.SpecImport
---@param result table<string, lz.n.Plugin>
local function import_spec(spec, result)
    if spec.import == "lz.n" then
        vim.schedule(function()
            vim.notify("Plugins modules cannot be called 'lz.n'", vim.log.levels.ERROR)
        end)
        return
    end
    if type(spec.import) ~= "string" then
        vim.schedule(function()
            vim.notify(
                "Invalid import spec. The 'import' field should be a module name: " .. vim.inspect(spec),
                vim.log.levels.ERROR
            )
        end)
        return
    end
    if spec.enabled == false or (type(spec.enabled) == "function" and not spec.enabled()) then
        return
    end
    local modpath = mod_name_to_path(spec.import)
    local import_root = vim.api.nvim_get_runtime_file(vim.fs.joinpath("lua", modpath .. ".lua"), true)
    if #import_root == 1 then
        import_modname(modpath, result)
    end
    local import_dir = vim.api.nvim_get_runtime_file(vim.fs.joinpath("lua", modpath), true)
    if #import_dir > 0 then
        local dir = import_dir[1]
        local handle = vim.uv.fs_scandir(dir)
        while handle do
            local name, ty = vim.uv.fs_scandir_next(handle)
            local path = vim.fs.joinpath(dir, name)
            ty = ty or vim.uv.fs_stat(path).type
            if not name then
                break
                -- XXX: "link" is required to support Nix.
                -- It seems to break in tests with with local symlinks
            elseif (ty == "file" or ty == "link") and name:sub(-4) == ".lua" then
                local submodname = name:sub(1, -5)
                import_modname(modpath .. "." .. submodname, result)
            elseif ty == "directory" and vim.uv.fs_stat(vim.fs.joinpath(path, "init.lua")) then
                import_modname(modpath .. "." .. name, result)
            end
        end
    end
end

---@param spec lz.n.PluginSpec
---@return lz.n.Plugin
local function parse(spec)
    ---@type lz.n.Plugin
    ---@diagnostic disable-next-line: assign-type-mismatch
    local result = vim.deepcopy(spec)
    result.name = spec[1]
    result[1] = nil
    require("lz.n.handler").parse(result, spec)
    return result
end

---XXX: This is unsafe because we assume a prior `vim.islist` check
---
---@param spec lz.n.Spec
---@return boolean
local function is_list_with_single_spec_unsafe(spec)
    return #spec == 1 and type(spec[1]) == "table"
end

---@param spec lz.n.Spec
---@return boolean
function M.is_spec_list(spec)
    return #spec > 1 or vim.islist(spec) and #spec > 1 or is_list_with_single_spec_unsafe(spec)
end

---@param spec lz.n.Spec
---@return boolean
function M.is_single_plugin_spec(spec)
    return type(spec[1]) == "string"
end

---@private
---@param spec lz.n.Spec
---@param result table<string, lz.n.Plugin>
function M._normalize(spec, result)
    if M.is_spec_list(spec) then
        ---@param sp lz.n.Spec
        vim.iter(spec):each(function(sp)
            M._normalize(sp, result)
        end)
    elseif M.is_single_plugin_spec(spec) then
        ---@cast spec lz.n.PluginSpec
        result[spec[1]] = parse(spec)
    elseif spec.import then
        ---@cast spec lz.n.SpecImport
        import_spec(spec, result)
    elseif spec.spec and spec.spec.name then
        -- spec passed in via vim.pack `data` field
        ---@cast spec lz.n.pack.LoadOpts

        ---@type lz.n.PluginSpec
        local plugin_spec = vim.tbl_deep_extend("force", { spec.spec.name }, spec.spec.data or {})
        result[spec.spec.name] = parse(plugin_spec)
    else
        error("unable to normalize plugin spec: " .. vim.inspect(spec))
    end
end

---@param result table<string, lz.n.Plugin>
local function remove_disabled_plugins(result)
    ---@param plugin lz.n.Plugin
    vim.iter(result):each(function(_, plugin)
        local disabled = plugin.enabled == false or (type(plugin.enabled) == "function" and not plugin.enabled())
        if disabled then
            result[plugin.name] = nil
        end
    end)
end

---@param spec lz.n.Spec
---@return table<string, lz.n.Plugin>
function M.parse(spec)
    local result = {}
    M._normalize(spec, result)
    remove_disabled_plugins(result)
    return result
end

return M
