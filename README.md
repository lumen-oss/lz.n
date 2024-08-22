<!-- markdownlint-disable MD028 -->
# :sloth: lz.n

[![Neovim][neovim-shield]][neovim-url]
[![Lua][lua-shield]][lua-url]
[![LuaRocks][luarocks-shield]][luarocks-url]

A dead simple lazy-loading Lua library for Neovim plugins.

It is intended to be used

- by users of plugin managers that don't provide a convenient API for lazy-loading.
- by plugin managers, to provide a convenient API for lazy-loading.

> [!NOTE]
>
> **Should I lazy-load plugins?**
>
> It should be a plugin author's responsibility to ensure their plugin doesn't
> unnecessarily impact startup time, not yours!
>
> See [our "DO's and DONT's" guide for plugin developers](https://github.com/nvim-neorocks/nvim-best-practices?tab=readme-ov-file#sleeping_bed-lazy-loading).
>
> Regardless, the current status quo is horrible, and some authors may
> not have the will or capacity to improve their plugins' startup impact.
>
> If you find a plugin that takes too long to load,
> or worse, forces you to load it manually at startup with a
> call to a heavy `setup` function,
> consider opening an issue on the plugin's issue tracker.

## :star2: Features

- API for lazy-loading plugins on:
  - Events (`:h autocmd-events`)
  - `FileType` events
  - Key mappings
  - User commands
  - Colorscheme events
- Works with:
  - Neovim's built-in `:h packpath` (`:h packadd`)
  - Any plugin manager that supports manually lazy-loading
    plugins by name
- Configurable in multiple files

## :moon: Introduction

`lz.n` provides abstractions for lazy-loading Neovim plugins,
with an API that is loosely based on [`lazy.nvim`](https://github.com/folke/lazy.nvim),
but reduced down to the very basics required for lazy-loading only.

### :milky_way: Philosophy

`lz.n` is designed based on the UNIX philosophy: Do one thing well.

### :zzz: Comparison with `lazy.nvim`

- `lz.n` is **not a plugin manager**, but focuses **on lazy-loading only**.
  It is intended to be used with (or by) a plugin manager.
- The feature set is minimal, to [reduce code complexity](https://grugbrain.dev/)
  and simplify the API.
  For example, the following `lazy.nvim` features are **out of scope**:
  - Merging multiple plugin specs for a single plugin
    (primarily intended for use by Neovim distributions).
  - `lazy.vim` completely disables and takes over Neovim's
    built-in loading mechanisms, including
    adding a plugin's API (`lua`, `autoload`, ...)
    to the runtimepath.
    `lz.n` doesn't.
    Its only concern is plugin initialization, which is
    the bulk of the startup overhead.
  - Automatic lazy-loading of Lua modules on `require`.
  - Automatic lazy-loading of colorschemes.
    `lz.n` provides a `colorscheme` handler in the plugin spec.
  - Heuristics for determining a `main` module and automatically calling
    a `setup()` function.
  - Heuristics for loading plugins on `require`.
    You can use [`lzn-auto-require`](https://github.com/horriblename/lzn-auto-require)
    for that.
  - Plugin spec fields (like `lazy.nvim`'s `dependencies`)
    for influencing the order in which plugins are loaded.
    See also: [Plugin dependencies](#plugin-dependencies).
  - Abstractions for plugin configuration with an `opts` table.
    `lz.n` provides simple hooks that you can use to specify
    when to load configurations.
  - Features related to plugin management.
  - Profiling tools.
  - UI.
- Some configuration options are different.

## :pencil: Requirements

- `Neovim >= 0.10.0`

## :wrench: Configuration

You can override the function used to load plugins.
`lz.n` has the following default:

```lua
vim.g.lz_n = {
    ---@type fun(name: string)
    load = vim.cmd.packadd,
}
```

## :books: Usage

```lua
require("lz.n").load(plugins)
```

- **plugins**: this should be a `table` or a `string`
  - `table`:
    - A list with your [Plugin Specs](#plugin-spec)
    - Or a single plugin spec.
  - `string`: a Lua module name that contains your [Plugin Spec](#plugin-spec).
    See [Structuring Your Plugins](#structuring-your-plugins)

> [!TIP]
>
> You can call `load()` as you would call `lazy.nvim`'s `setup()`.
> Or, you can also use it to register individual plugin specs for lazy
> loading.

> [!IMPORTANT]
>
> Since merging configs is out of scope, calling `load()` with conflicting
> plugin specs is not supported.

### Plugin spec

<!-- markdownlint-disable MD013 -->
| Property         | Type | Description | `lazy.nvim` equivalent |
|------------------|------|-------------|-----------------------|
| **[1]** | `string` | The plugin's name (not the module name). This is what is passed to the `load(name)` function. | `name`[^1] |
| **enabled** | `boolean?` or `fun():boolean` | When `false`, or if the `function` returns false, then this plugin will not be included in the spec. | `enabled` |
| **beforeAll** | `fun(lz.n.Plugin)?` | Always executed before any plugins are loaded. | `init` |
| **before** | `fun(lz.n.Plugin)?` | Executed before a plugin is loaded. | None |
| **after** | `fun(lz.n.Plugin)?` | Executed after a plugin is loaded. | `config` |
| **event** | `string?` or `{event?:string\|string[], pattern?:string\|string[]}\` or `string[]` | Lazy-load on event. Events can be specified as `BufEnter` or with a pattern like `BufEnter *.lua`. | `event` |
| **cmd** | `string?` or `string[]` | Lazy-load on command. | `cmd` |
| **ft** | `string?` or `string[]` | Lazy-load on filetype. | `ft` |
| **keys** | `string?` or `string[]` or `lz.n.KeysSpec[]` | Lazy-load on key mapping. | `keys` |
| **colorscheme** | `string?` or `string[]` | Lazy-load on colorscheme. | None. `lazy.nvim` lazy-loads colorschemes automatically[^2]. |
| **priority** | `number?` | Only useful for **start** plugins (not lazy-loaded) to force loading certain plugins first. Default priority is `50` (or `1000` if `colorscheme` is set). | `priority` |
| **load** | `fun(string)?` | Can be used to override the `vim.g.lz_n.load()` function for an individual plugin. | None. |
<!-- markdownlint-enable MD013 -->

[^1]: In contrast to `lazy.nvim`'s `name` field, a `lz.n.PluginSpec`'s `name` *is not optional*.
      This is because `lz.n` is not a plugin manager and needs to be told which
      plugins to load.
[^2]: The reason this library doesn't lazy-load colorschemes automatically is that
      it would have to know where the plugin is installed in order to determine
      which plugin to load.

### User events

- `DeferredUIEnter`: Triggered when `load()` is done and after `UIEnter`.
  Can be used as an `event` to lazy-load plugins that are not immediately needed
  for the initial UI[^3].

[^3]: This is equivalent to `lazy.nvim`'s `VeryLazy` event.

### Plugin dependencies

This library does not provide a `lz.n.PluginSpec` field like `lazy.nvim`'s `dependencies`.
The rationale behind this is that you shouldn't need it.
Instead, you can utilise the [`trigger_load`](#trigger_load) function
in a `before` or `after` hook.

However, we generally do not recommend this approach.
Most plugins primarily rely on the Lua libraries of other plugins,
which can be added to the `:h package.path` without any noticeable
impact on startup time.

Relying on another plugin's `plugin` or `after/plugin` scripts is considered a bug,
as Neovim's built-in loading mechanism does not guarantee initialisation order.
Requiring users to manually call a `setup` function [is an anti pattern](https://github.com/nvim-neorocks/nvim-best-practices?tab=readme-ov-file#zap-initialization).
Forcing users to think about the order in which they load plugins that
extend or depend on each other is even worse. We strongly suggest opening
an issue or submitting a PR to fix this upstream.
However, if you're looking for a temporary workaround, you can use
`trigger_load` in a `before` or `after` hook, or bundle the relevant plugin configurations.

> [!NOTE]
>
> - This does not work with plugins that rely on `after/plugin`, such as many
>   nvim-cmp sources, because Neovim's `:h packadd` does not source
>   `after/plugin` scripts after startup has completed.
>   We recommend bundling such plugins with their extensions, or sourcing
>   the `after` scripts manually.
>
> - Why not provide a `dependencies` field for plugins that don't adhere
>   to best practices?
>   Because it's unnecessary. By using the `before` and `after` hooks,
>   you gain full control over when to load another plugin, without cluttering
>   the API.

> [!TIP]
>
> We recommend [care.nvim](https://max397574.github.io/care.nvim/)
> as a modern alternative to nvim-cmp.

### Examples

```lua
require("lz.n").load {
    {
        "neo-tree.nvim",
        keys = {
            -- Create a key mapping and lazy-load when it is used
            { "<leader>ft", "<CMD>Neotree toggle<CR>", desc = "NeoTree toggle" },
        },
        after = function()
            require("neo-tree").setup()
        end,
    },
    {
        "crates.nvim",
        -- lazy-load when opening a toml file
        ft = "toml",
    },
    {
        "sweetie.nvim",
        -- lazy-load when setting the `sweetie` colorscheme
        colorscheme = "sweetie",
    },
    {
        "vim-startuptime",
        cmd = "StartupTime",
        before = function()
            -- Configuration for plugins that don't force you to call a `setup` function
            -- for initialization should typically go in a `before`
            --- or `beforeAll` function.
            vim.g.startuptime_tries = 10
        end,
    },
    {
        "care.nvim",
        -- load care.nvim on InsertEnter
        event = "InsertEnter",
    },
    {
        "dial.nvim",
        -- lazy-load on keys. -- Mode is `n` by default.
        keys = { "<C-a>", { "<C-x>", mode = "n" } },
    },
}
```

<!-- markdownlint-disable -->
<details>
  <summary>
    <b><a href="https://github.com/savq/paq-nvim">paq-nvim</a> example</b>
  </summary>

  ```lua
  require "paq" {
      { "nvim-telescope/telescope.nvim", opt = true }
      { "NTBBloodBatch/sweetie.nvim", opt = true }
  }

  require("lz.n").load {
      {
          "telescope.nvim",
          cmd = "Telescope",
      },
      {
          "sweetie.nvim",
          colorscheme = "sweetie",
      },
  }
  ```

</details>

<details>
  <summary>
    <b><a href="https://wiki.nixos.org/wiki/Neovim">Nix (Home Manager) example</a></b>
  </summary>

  ```nix
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins [
      lz-n
      {
        plugin = pkgs.vimPlugins.telescope-nvim;
        config = ''
          require("lz.n").load {
            "telescope.nvim",
            cmd = "Telescope",
          }
        '';
        type = "lua";
        optional = true;
      }
      {
        plugin = pkgs.vimPlugins.sweetie-nvim;
        config = ''
          require("lz.n").load {
            "sweetie.nvim",
            colorscheme = "sweetie",
          }
        '';
        type = "lua";
        optional = true;
      }
    ];
  };
  ```

</details>
<!-- markdownlint-restore -->

### Structuring Your Plugins

As is the case with `lazy.nvim`, you can also split your plugin specs
into multiple files.
Instead of passing a spec table to `load()`, you can use a Lua module.
The function will merge specs from the **module** and any top-level **sub-modules**
together in the final spec, so it is not needed to add `require` calls
in your main plugin file to the other files.

Example:

- `~/.config/nvim/init.lua`

```lua
require("lz.n").load("plugins")
```

- `~/.config/nvim/lua/plugins.lua` or `~/.config/nvim/lua/plugins/init.lua`
  **(this file is optional)**

```lua
return {
    { "sweetie.nvim" },
    { "telescope.nvim", cmd = "Telescope" },
}
```

- `lz.n` will automatically merge any Lua file in `~/.config/nvim/lua/plugins/*.lua`
  with the main plugin spec[^4].

[^4]: It *does not* merge multiple specs for the same plugin from different files.

Example structure:

```sh
── nvim
  ├── lua
  │  └── plugins # Your plugin specs go here.
  │     └── init.lua # Optional top-level module returning a list of specs
  │     └── neorg.lua # Single spec
  │     └── telescope/init.lua # Single spec
  ├── init.lua
```

Or

```sh
── nvim
  ├── lua
  │  └── plugins.lua # Optional top-level module returning a list of specs
  ├── init.lua
```

## :electric_plug: API

### Custom handlers

You may register your own handlers to lazy-load plugins via
other triggers not already covered by the plugin spec.

You should register all handlers before calling `require('lz.n').load`,
because they will not be retroactively applied to
the `load` calls that occur before they are registered.

The `register_handler` function returns a `boolean` that indicates success.

```lua
---@param handler lz.n.Handler
---@return boolean success
require("lz.n").register_handler(handler)
```

#### `lz.n.Handler`

<!-- markdownlint-disable MD013 -->
| Property   | Type                       | Description                                               |
| ---        | ---                        | ---                                                       |
| spec_field | `string`                   | the `lz.n.PluginSpec` field used to configure the handler |
| add        | `fun(plugin: lz.n.Plugin)` | adds a plugin to the handler                              |
| del        | `fun(name: string)`        | removes a plugin from the handler by name                 |
| lookup     | `fun(name: string`         | lookup a plugin managed by this handler by name           |
<!-- markdownlint-enable MD013 -->

> [!TIP]
>
> For some examples, look at
>
> - [The built-in handlers](./lua/lz/n/handler)
> - [The Wiki](https://github.com/nvim-neorocks/lz.n/wiki/Custom-handler-examples)

### Lua API

The following Lua functions are part of the public API.

> [!WARNING]
>
> If you use internal functions or modules that are not listed here,
> things may break without a major version bump.

#### `trigger_load`

You can manually load a plugin (and run the hooks from the spec)
with the following function:

```lua
  ---@overload fun(plugin: lz.n.Plugin | lz.n.Plugin[])
  ---@overload fun(plugin: string | string[], opts: lz.n.lookup.Opts)
  require('lz.n').trigger_load
```

The function accepts plugin names (`string | string[]`, when called in another
plugin's hook), or `lz.n.Plugin` items (when called by a `lz.n.Handler`).
If called with a plugin name, it will use the registered
handlers' `lookup` functions to search for a plugin to load
(loading the first one it finds).
Once a plugin has been loaded, it will be removed from all handlers (via `del`).
As a result, calling `trigger_load` with a plugin name is idempotent.

> [!IMPORTANT]
>
> This can be used to influence the order in which plugins are lazy-loaded,
> for example when a plugin depends on another one.
>
> However, we strongly recommend you consider alternatives before doing so.
> lz.n was designed with automatic dependency management in mind and hence
> **does not provide an API** to declare dependencies in the `lz.n.PluginSpec`.
> Plugin dependencies are usually just Lua libraries, which can be added to the
> `package.path` without any noticeable impact on startup time.
>
> If a plugin relies on another plugin's `plugin/` or `after/plugin/` scripts
> having been sourced before it is loaded, we consider this a bug, as this is not
> supported by Neovim's built-in loading mechanisms.
>
> Similarly, requiring users to worry about *the order in which they configure*
> plugins is bad design and defeats the purpose of automatic dependency management.

#### `lookup`

To lookup a plugin that is pending to be loaded by name, use:

```lua
  ---@type fun(name: string, opts: lz.n.lookup.Opts):lz.n.Plugin?
  require('lz.n').lookup
```

The lookup, as well as `trigger_load(string|string[])` can be
fine-tuned with a `lz.n.lookup.Opts` table:

```lua
--- The handlers to include in the search (filtered by `spec_field`)
--- In case of multiple filters, the order of the filter list
--- determines the order in which handlers' `lookup` functions are called.
---@field filter string | string[]
---@class lz.n.lookup.Opts
```

## :green_heart: Contributing

All contributions are welcome!
See [CONTRIBUTING.md](./CONTRIBUTING.md).

## :book: License

This library is [licensed](./LICENSE) according to GPL version 2
or (at your option) any later version.

<!-- MARKDOWN LINKS & IMAGES -->
[neovim-shield]: https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white
[neovim-url]: https://neovim.io/
[lua-shield]: https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white
[lua-url]: https://www.lua.org/
[luarocks-shield]:
https://img.shields.io/luarocks/v/neorocks/lz.n?logo=lua&color=purple&style=for-the-badge
[luarocks-url]: https://luarocks.org/modules/neorocks/lz.n
