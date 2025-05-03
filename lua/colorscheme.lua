vim.cmd.colorscheme('catppuccin-mocha')

-- Highlight errors
vim.api.nvim_set_hl(0, 'LspWarningHighlight', { fg = '#FAB387' })
vim.api.nvim_set_hl(0, 'LspWarningVirtualText', { fg = '#FAB387', bg = '#3B3A32' })
