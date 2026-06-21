local lz = require("lz.n")
vim.g.lz_n = {
    load = function() end,
}
local loader = require("lz.n.loader")
local spy = require("luassert.spy")

describe("lz.n", function()
    describe("load", function()
        it("list of plugin specs", function()
            local spy_load = spy.on(loader, "_load")
            lz.load({
                {
                    "neorg",
                },
                {
                    "crates.nvim",
                    ft = { "toml", "rust" },
                },
                {
                    "telescope.nvim",
                    keys = { { "<leader>tt", mode = { "n", "v" } } },
                    cmd = "Telescope",
                },
                {
                    "telescope-manix",
                    keys = { { "<leader>tn", mode = { "n", "v" }, ft = { "nix" } } },
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
        it("individual plugin specs", function()
            local spy_load = spy.on(loader, "_load")
            lz.load({
                "foo.nvim",
                keys = "<leader>ff",
            })
            assert.spy(spy_load).called(0)
            local feed = vim.api.nvim_replace_termcodes("<Ignore><leader>ff", true, true, true)
            vim.api.nvim_feedkeys(feed, "ix", false)
            assert.spy(spy_load).called(1)
            lz.load({
                "bar.nvim",
                cmd = "Bar",
            })
            vim.cmd.Bar()
            assert.spy(spy_load).called(2)
        end)
        it("keys with callback (#154)", function()
            local spy_load = spy.on(loader, "_load")
            local left_callback_count = 0
            local right_callback_count = 0
            local after_invoked = false
            lz.load({
                "smart-splits.nvim",
                after = function()
                    after_invoked = true
                end,
                keys = {
                    {
                        "<A-Left>",
                        function()
                            assert.spy(spy_load).called(1)
                            assert.True(after_invoked)
                            left_callback_count = left_callback_count + 1
                        end,
                        desc = "Resize Left",
                        mode = "n",
                        noremap = true,
                    },
                    {
                        "<A-Right>",
                        function()
                            -- We only want to load once.
                            assert.spy(spy_load).called(1)
                            right_callback_count = right_callback_count + 1
                        end,
                        desc = "Resize Right",
                        mode = "n",
                        noremap = true,
                    },
                },
            })
            assert.spy(spy_load).called(0)
            local feed = vim.api.nvim_replace_termcodes("<Ignore><A-Left>", true, true, true)
            vim.api.nvim_feedkeys(feed, "ix", false)
            assert.same(1, left_callback_count)
            vim.api.nvim_feedkeys(feed, "ix", false)
            assert.same(2, left_callback_count)
            feed = vim.api.nvim_replace_termcodes("<Ignore><A-Right>", true, true, true)
            vim.api.nvim_feedkeys(feed, "ix", false)
            assert.same(1, right_callback_count)
            vim.api.nvim_feedkeys(feed, "ix", false)
            assert.same(2, right_callback_count)
        end)
        it("can override load implementation via plugin spec", function()
            local loaded = false
            lz.load({
                "baz.nvim",
                keys = "<leader>bb",
                load = function()
                    loaded = true
                end,
            })
            assert.False(loaded)
            local feed = vim.api.nvim_replace_termcodes("<Ignore><leader>bb", true, true, true)
            vim.api.nvim_feedkeys(feed, "ix", false)
            assert.True(loaded)
        end)
        it("list with a single plugin spec", function()
            local spy_load = spy.on(loader, "_load")
            lz.load({
                {
                    "single.nvim",
                    cmd = "Single",
                },
            })
            assert.spy(spy_load).called(0)
            pcall(vim.cmd.Single)
            assert.spy(spy_load).called(1)
            assert.spy(spy_load).called_with({
                name = "single.nvim",
                lazy = true,
                cmd = { "Single" },
            })
        end)
        it("eagerly load if lazy=False", function()
            local spy_load = spy.on(loader, "_load")
            lz.load({
                {
                    "foo.nvim",
                    cmd = "Foo",
                    lazy = false,
                },
            })
            assert.spy(spy_load).called(1)
            assert.spy(spy_load).called_with({
                name = "foo.nvim",
                cmd = { "Foo" },
                lazy = false,
            })
        end)
        it("cmd handler does not delete user commands created in before hook", function()
            --
            lz.load({
                {
                    "foo.nvim",
                    cmd = { "Foo", "Bar" },
                    before = function()
                        vim.api.nvim_create_user_command("Foo", function() end, {})
                        vim.api.nvim_create_user_command("Bar", function() end, {})
                    end,
                },
            })
            vim.cmd.Foo()
            vim.cmd.Bar()
        end)
    end)
end)
