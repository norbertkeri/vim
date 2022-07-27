require'nvim-treesitter.configs'.setup {
  ensure_installed = {"rust", "css", "dockerfile", "yaml", "fish", "html", "javascript", "json", "python", "php", "scss", "toml", "typescript"},
  indent = {
    enable = true
  },
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    --colors = {}, -- table of hex strings
    --termcolors = {} -- table of colour name strings
  }
}

local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
  },
  extensions = {
      ["ui-select"] = {
          require("telescope.themes").get_dropdown {
              -- even more opts
          }
      }
  }
}
require('telescope').load_extension('fzf')
require('telescope').load_extension('ui-select')

require'colorizer'.setup()
require('gitsigns').setup()
require('trouble').setup()

require('leap').set_default_keymaps()

local catppuccin = require("catppuccin")
catppuccin.setup({
    transparent_background = false,
    term_colors = false,
    styles = {
        comments = "italic",
        functions = "italic",
        keywords = "italic",
        strings = "NONE",
        variables = "NONE",
    },
    integrations = {
        treesitter = true,
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = "italic",
                hints = "italic",
                warnings = "italic",
                information = "italic",
            },
            underlines = {
                errors = "italic",
                hints = "italic",
                warnings = "italic",
                information = "italic",
            },
        },
        lsp_trouble = true,
        lsp_saga = false,
        gitgutter = false,
        gitsigns = true,
        telescope = true,
        nvimtree = {
            enabled = false,
            show_root = false,
        },
        which_key = false,
        indent_blankline = {
            enabled = false,
            colored_indent_levels = false,
        },
        dashboard = false,
        neogit = false,
        vim_sneak = false,
        fern = false,
        barbar = false,
        bufferline = false,
        markdown = false,
        lightspeed = false,
        ts_rainbow = false,
        hop = false,
    },
})

if vim.env.TERM == 'xterm-kitty' then
  vim.cmd([[autocmd UIEnter * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]])
  vim.cmd([[autocmd UILeave * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]])
end

local function delete_special()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return "\"_dd"
  else
    return "dd"
  end
end

vim.keymap.set( "n", "dd", delete_special, { noremap = true, expr = true } )
require "lsp_signature".setup()
local modname = ...
require(modname .. '.lsp')
require(modname .. '.toggleterm')
require(modname .. '.lualine')
require(modname .. '.toggletasks')
require "crates".setup()
require "detect-language".setup()
require"fidget".setup{}
