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
    { 'j-hui/fidget.nvim' },
    { 'kylechui/nvim-surround' },
    { 'ggandor/flit.nvim' },
    { 'numToStr/Comment.nvim' },
}, autosetup)

local plugins = {
    {
        'ggandor/leap.nvim',
        config = function()
            require('leap').set_default_keymaps()
        end
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
    -- treesitter might handle these automatically
    --'pangloss/vim-javascript',
    --'mxw/vim-jsx', { 'for': 'javascript.jsx' }
    --'hynek/vim-python-pep8-indent', { 'for': 'python' }
    --'othree/html5.vim'
    --'jparise/vim-graphql', { 'for': 'graphql' }
    --'rust-lang/rust.vim'
    --'leafgarland/typescript-vim'
    -- 'peitalin/vim-jsx-typescript'
    {
        'dyng/ctrlsf.vim',
        config = function()
            -- Autofocus
            vim.g.ctrlsf_auto_focus = { at = "start" }

            vim.g.ctrlsf_mapping = {next = "n", prev = "N", vsplit = "v", split = "s"}

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
    {
        'kevinhwang91/nvim-hlslens',
        config = function()
            require('hlslens').setup({
                calm_down = true
            })
            local kopts = {noremap = true, silent = true}

            vim.api.nvim_set_keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
        end
    },
    {
        'folke/neodev.nvim',
        enabled = false
    },
    'wellle/targets.vim',
    'mbbill/undotree',
    {
        'norcalli/nvim-colorizer.lua',
        config = function ()
            require('colorizer').setup({'*'}, {
                mode = 'foreground', rgb_fn = true
            })
        end
    },
}

local ret = _.merge_list(autoplugins, plugins)

return ret
