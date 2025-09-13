local lz = require("lz.n")
vim.g.lz_n = {
    load = function() end,
}
local loader = require("lz.n.loader")
local spy = require("luassert.spy")

describe("lz.n", function()
    it("list of lz.n.pack.Spec", function()
        local spy_load = spy.on(loader, "_load")
        lz.load({
            spec = {
                name = "neorg",
                data = {},
                src = "",
            },
        })
        lz.load({
            spec = {
                name = "crates.nvim",
                data = {
                    ft = { "toml", "rust" },
                },
                src = "",
            },
        })
        lz.load({
            spec = {
                name = "telescope.nvim",
                data = {
                    keys = { { "<leader>tt", mode = { "n", "v" } } },
                    cmd = "Telescope",
                },
                src = "",
            },
        })
        lz.load({
            spec = {
                name = "telescope-manix",
                data = {
                    keys = { { "<leader>tn", mode = { "n", "v" }, ft = { "nix" } } },
                },
                src = "",
            },
        })
        assert.spy(spy_load).called(1)
        assert.spy(spy_load).called_with({
            name = "neorg",
            lazy = false,
        })
        vim.api.nvim_exec_autocmds("FileType", { pattern = "toml" })
        assert.spy(spy_load).called(2)
        local plugin = {
            name = "crates.nvim",
            lazy = true,
        }
        require("lz.n.handler.ft").parse(plugin, { "toml", "rust" })
        assert.spy(spy_load).called_with(plugin)
        vim.cmd.Telescope()
        assert.spy(spy_load).called(3)
        assert.spy(spy_load).called_with({
            name = "telescope.nvim",
            lazy = true,
            cmd = { "Telescope" },
            keys = {
                { id = "\\tt", lhs = "<leader>tt", mode = "n" },
                { id = "\\tt (v)", lhs = "<leader>tt", mode = "v" },
            },
        })
        vim.api.nvim_exec_autocmds("FileType", { pattern = "nix" })
        assert.spy(spy_load).called(3)
        local feed = vim.api.nvim_replace_termcodes("<Ignore><leader>tn", true, true, true)
        vim.api.nvim_feedkeys(feed, "ix", false)
        assert.spy(spy_load).called(4)
    end)
end)
