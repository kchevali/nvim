
-- Add neovim venv python to path
vim.env.PATH = vim.env.PATH .. ':' .. vim.fn.expand('/wv/kevche06/bin/nvim_py/bin')

-- Set <leader> key
vim.g.mapleader = ' '

-- Handle clipboard
if vim.fn.executable("xclip") == 1 then
    vim.o.clipboard = 'unnamedplus'
    vim.g.clipboard = {
        name = "my-clipboard",
        copy = {
            ["+"] = "xclip -selection primary -in",
            ["*"] = "xclip -selection primary -in"
        },
        paste = {
            ["+"] = "xclip -selection primary -out",
            ["*"] = "xclip -selection primary -out"
        },
        cache_enabled = 0
    }
end


vim.o.completeopt = 'menu,menuone,noselect,preview'

-- Setup Python interpreter
if vim.fn.filereadable(vim.fn.expand('$PYTHON_ENV_PATH/bin/python3')) == 1 then
    vim.g.python3_host_prog = vim.fn.expand('$PYTHON_ENV_PATH/bin/python3')
else
    vim.g.python3_host_prog = '/wv/kevche06/bin/nvim_py/bin/python3'
end

-- Indentation options
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Relative line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Show trailing whitespace
vim.o.list = true
vim.o.listchars = 'tab:>-,trail:~,extends:>,precedes:<'

-- Add the vertical boundary at 80 chars
vim.o.colorcolumn = '80'
vim.o.textwidth = 79

-- Encoding and term colors
vim.o.encoding = 'UTF-8'
vim.o.termguicolors = true

-- Smart case
vim.o.ignorecase = true
vim.o.smartcase = true

-- Persistent undo
vim.o.undofile = true
vim.o.undodir = vim.fn.expand('~/.config/nvim/undo/')

-- IndentLine settings
vim.g.indentLine_char = '│'
vim.g.indentLine_enabled = 1
vim.g.indentLine_concealcursor = ''
vim.g.indentLine_conceallevel = 0
