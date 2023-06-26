local _ = require("visko.helpers")

local function autosetup(...)
    local url, modulename = unpack(...)
    if modulename == nil then
        modulename = url:match("[^/]+/([^.]+)")
    end
    return {
        url,
        config = function()
            require(modulename).setup()
        end
    }
end

local autoplugins = _.map({
    { 'lewis6991/gitsigns.nvim' },
    { 'folke/trouble.nvim' },
    { 'kylechui/nvim-surround' },
    { 'ggandor/flit.nvim' },
    { 'numToStr/Comment.nvim' },
}, autosetup)

local plugins = {
    { 'j-hui/fidget.nvim', config = function()
        require('fidget').setup({
            text = {
                spinner = "moon"
            }
        })
        end
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n", "o", "x" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
        },
    },
    {
        'saecki/crates.nvim',
        tag = 'v0.3.0',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require "crates".setup()
        end
    },
    {
        'bfredl/nvim-miniyank',
        config = function()
            vim.keymap.set('n', 'p', '<Plug>(miniyank-autoput)')
            vim.keymap.set('n', 'P', '<Plug>(miniyank-autoPut)')
            vim.keymap.set('n', '<leader>p', '<Plug>(miniyank-cycle)')
            vim.keymap.set('n', '<leader>P', '<Plug>(miniyank-cycleback)')
        end
    },
    {
        'dyng/ctrlsf.vim',
        config = function()
            -- Autofocus
            vim.g.ctrlsf_auto_focus = { at = "start" }

            vim.g.ctrlsf_mapping = {next = "n", prev = "N", vsplit = "v", split = "s", open = {"<cr>", "o"}, popen = "p", quit = "q"}

            -- Search regexes by default
            vim.g.ctrlsf_regex_pattern = 1
            -- Only indent two lines, instead of 4 in search results
            vim.g.ctrlsf_indent = 2
            vim.keymap.set('n', '<leader>F', '<Plug>CtrlSFPrompt')
            vim.keymap.set('n', '!', '<Plug>CtrlSFCwordExec')
            vim.keymap.set('v', '!', '<Plug>CtrlSFVwordExec')
        end
    },
    {
        'mg979/vim-visual-multi',
        branch = 'master',
        config = function()
            vim.g.VM_maps = {
                ["Skip Region"] = "s"
            }
        end
    },
    'folke/neodev.nvim',
    'wellle/targets.vim',
    'mbbill/undotree',
    {
        'norcalli/nvim-colorizer.lua',
        config = function ()
            require('colorizer').setup({'*'}, {
                rgb_fn = true
            })
        end
    },
    {
        "Bryley/neoai.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        cmd = {
            "NeoAI",
            "NeoAIOpen",
            "NeoAIClose",
            "NeoAIToggle",
            "NeoAIContext",
            "NeoAIContextOpen",
            "NeoAIContextClose",
            "NeoAIInject",
            "NeoAIInjectCode",
            "NeoAIInjectContext",
            "NeoAIInjectContextCode",
        },
        keys = {
            { "<leader>as", desc = "summarize text" },
            { "<leader>ag", desc = "generate git message" },
        },
        config = function()
            require("neoai").setup({
                -- Options go here
            })
        end,
    }
}

local ret = _.merge_list(autoplugins, plugins)

return ret
