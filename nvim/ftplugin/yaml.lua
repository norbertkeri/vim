vim.opt_local.ts = 2
vim.opt_local.sts = 2
vim.opt_local.sw = 2

vim.opt_local.foldenable = false
vim.opt_local.indentkeys:remove("0#")

vim.cmd([[
function! GoToNextIndent(inc)
    " Get the cursor current position
    let currentPos = getpos('.')
    let currentLine = currentPos[1]
    let matchIndent = 0

    " Look for a line with the same indent level whithout going out of the buffer
    while !matchIndent && currentLine != line('$') + 1 && currentLine != -1
        let currentLine += a:inc
        let matchIndent = indent(currentLine) == indent('.')
    endwhile

    " If a line is found go to this line
    if (matchIndent)
        let currentPos[1] = currentLine
        call setpos('.', currentPos)
    endif
endfunction
]])

vim.keymap.set("n", "<leader>ij", ":call GoToNextIndent(1)<cr>", { buffer = true })
vim.keymap.set("n", "<leader>ik", ":call GoToNextIndent(-1)<cr>", { buffer = true })
