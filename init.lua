
vim.diagnostic.config({
    virtual_text = {
        spacing = 2,  -- Add spacing between the text and the diagnostic
    },
    signs = true,
    underline = true,
    update_in_insert = false, -- Disable updates while in insert mode for performance
})

require('plugins')
require('settings')
require('keymappings')
require('cmds')
require('colorscheme')

-- Source a local project file if it exists
local local_config = vim.fn.getcwd() .. '/.nvim.lua'
if vim.fn.filereadable(local_config) == 1 then
    dofile(local_config)
end
