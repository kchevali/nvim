-- Autocommands
local show_current_line_num_group = vim.api.nvim_create_augroup('ShowCurrentLineNum', { clear = true })
vim.api.nvim_create_autocmd('CursorMoved', {
    group = show_current_line_num_group,
    callback = function()
        vim.wo.number = true
    end,
})
vim.api.nvim_create_autocmd('CursorMovedI', {
    group = show_current_line_num_group,
    callback = function()
        vim.wo.number = true
    end,
})
vim.api.nvim_create_autocmd('InsertLeave', {
    group = show_current_line_num_group,
    callback = function()
        vim.wo.relativenumber = true
    end,
})

-- Custom commands
vim.api.nvim_create_user_command('Wbd', 'w | bd', {})

vim.api.nvim_create_user_command('ToggleIndent', function()
    if vim.o.shiftwidth == 2 then
        vim.o.shiftwidth = 4
        vim.o.tabstop = 4
        vim.o.expandtab = true
        print("Switched to 4 spaces for indentation")
    else
        vim.o.shiftwidth = 2
        vim.o.tabstop = 2
        vim.o.expandtab = true
        print("Switched to 2 spaces for indentation")
    end
end, {})

-- Function to delete swap file
vim.api.nvim_create_user_command('DeleteSwapFile', function()
    local swapfile_path = vim.fn.swapname(vim.fn.expand('%:p'))
    if vim.fn.filereadable(swapfile_path) == 1 then
        vim.fn.delete(swapfile_path)
        print("Deleted swap file: " .. swapfile_path)
    else
        print("No swap file found for the current buffer.")
    end
end, {})

-- Create a user command to fix all issues
vim.api.nvim_create_user_command('LspFixAll', function()
    vim.lsp.buf.format({ async = true })
end, {})

-- Use Vimade's fade/unfade functionality on FocusLost and FocusGained events
vim.api.nvim_create_autocmd("FocusLost", {
    pattern = "*",
    callback = function()
        vim.cmd("VimadeFadeActive")
    end,
})

vim.api.nvim_create_autocmd("FocusGained", {
    pattern = "*",
    callback = function()
        vim.cmd("VimadeUnfadeActive")
    end,
})
