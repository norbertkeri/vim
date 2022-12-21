return {
    { 'sindrets/diffview.nvim', config = function()
        require("diffview").setup({
            enhanced_diff_hl = true,
            hooks = {
                diff_buf_read = function(bufnr) 
                    vim.cmd("norm! zi")
                end,
                diff_buf_win_enter = function(bufnr) 
                    vim.opt_local.foldlevel = 99
                    vim.opt_local.foldenable = false
                    vim.cmd("norm! zi")
                end
            }
        })
    end
    }
}
