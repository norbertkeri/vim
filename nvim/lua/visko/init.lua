local function setup_persistent_undo()
    local undodir = os.getenv("HOME") .. "/.vimrepository/undodir"
    local handle = io.open(undodir)
    if handle then
        handle:close()
    else
        os.execute("mkdir -p " .. undodir)
    end
    vim.opt.undodir = undodir
    vim.opt.undofile = true
end

setup_persistent_undo()

require(... .. ".editor")
require(... .. ".lazy_bootstrap")
require("lazy").setup("visko.plugins")
require(... .. ".mappings")
require(... .. ".lsp")

Is_colemak = false

-- try to require a local file, but don't fail if it does not exist
pcall(require, "visko.local")

if vim.env.TERM == "xterm-kitty" then
    vim.cmd([[autocmd UIEnter * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]])
    vim.cmd([[autocmd UILeave * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]])
end

-- do not save empty lines into the paste buffer
local function delete_special()
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
    else
        return "dd"
    end
end

vim.keymap.set("n", "dd", delete_special, { expr = true })
