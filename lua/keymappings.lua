local wk = require("which-key")

wk.add({
    { "<leader>f", group = "find" },
    { "<leader>t", group = "test" },
    { "<leader>h", group = "harpoon" },
    { "<leader>c", group = "code actions" },
    { "<leader>b", group = "bufferline" },

    { "g", group = "info" },
})

local function map(mode, key, command, description)
    local opts = { noremap = true, silent = true, desc = description }
    vim.keymap.set(mode, key, command, opts)
end

-- Quit window
map('n', '<leader>q', ':q<CR>', "close window")

-- Toggle comments
map('n', '<C-_>', ':Commentary<CR>', "toggle comments")
map('v', '<C-_>', ':Commentary<CR>', "toggle comments")

-- Move lines
map('n', '<A-j>', ':m .+1<CR>==', "move down")
map('n', '<A-k>', ':m .-2<CR>==', "move up")
map('v', '<A-j>', ":m '>+1<CR>gv=gv", "move down")
map('v', '<A-k>', ":m '<-2<CR>gv=gv", "move up")

-- Split shortcuts
map('n', '|', ':vsplit<CR>', "vsplit")
map('n', '-', ':split<CR>', "hsplit")

-- Terminal mode mappings for switching panes
local nvim_tmux_nav = require('nvim-tmux-navigation')
map('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft, "move pane left")
map('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown, "move pane down")
map('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp, "move pane up")
map('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight, "move pane right")
map('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive, "move last active pane")
map('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext, "move next pane")

-- Code actions (LSP)
map('n', '<leader>ca', vim.lsp.buf.code_action, "code actions")
map('n', '<leader>cf', function() vim.lsp.buf.format({ async = true }) end, "lsp format")
map('n', '<leader>cw', ':%s/\\s\\+$//e<CR>', "remove trailing white space")


-- Telescope keybindings
map('n', '<leader>ff', '<cmd>Telescope find_files follow=true<CR>', "find files")
map('n', '<leader>fF', function()
    require('telescope.builtin').find_files({ follow = true, search_dirs = { ".", "./Isrc" } })
end, "find_files + Isrc/")
map('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', "live grep")
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', "buffers")
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', "tags")
map('n', '<leader>fc', '<cmd>Telescope resume<CR>', "resume")

-- Harpoon keybindings
-- Add file to Harpoon
map("n", "<leader>hx", require('harpoon.mark').add_file, "harpoon: add file")
map("n", "<leader>hn", require('harpoon.ui').nav_next, "harpoon: next")
map("n", "<leader>hp", require('harpoon.ui').nav_prev, "harpoon: prev")
map("n", "<leader>hh", "<cmd>Telescope harpoon marks<CR>", "harpoon: show")

map("n", "gd", "<cmd>Lspsaga goto_definition<CR>", "goto def")
map("n", "gr", "<cmd>Lspsaga finder<CR>", "show refs")
map("n", "gn", "<cmd>Lspsaga rename<CR>", "rename")
map("n", "go", "<cmd>Lspsaga outline<CR>", "outline")
map("n", "gh", "<cmd>Lspsaga hover_doc<CR>", "hover")
map("n", "gl", "<cmd>Lspsaga show_line_diagnostics<CR>", "show line errors")
map("n", "gb", "<cmd>Lspsaga show_buf_diagnostics<CR>", "show buffer errors")
map("n", "gw", "<cmd>Lspsaga show_workspace_diagnostics<CR>", "show all errors")

-- File explore keybinding
map("n", "<leader>e", ":Neotree toggle<CR>", "toggle neotree")

-- Bufferline keybinding
map('n', '<leader>bl', ':BufferLinePick<CR>', "pick tab")


-- Neotest keybindings
-- Run the nearest test under the cursor
map("n", "<leader>tn", function()
    require("neotest").run.run()
end, "run test")

-- Run all tests in the current file
map("n", "<leader>tf", function()
    require("neotest").run.run(vim.fn.expand("%"))
end, "run tests in file")

-- Open the test output window for the nearest test
map("n", "<leader>to", function()
    require("neotest").output.open({
        enter = true, -- Focus the window after opening
    })
end, "show test output")
-- Toggle the summary window (shows a list of all tests and their status)
map("n", "<leader>tt", function()
    require("neotest").summary.toggle()
end, "show all tests")

-- Jump to the next failed test
map("n", "<leader>tf", function()
    require("neotest").jump.next({ status = "failed" })
end, "jump to next failed test")

-- Jump to the previous failed test
map("n", "<leader>tp", function()
    require("neotest").jump.prev({ status = "failed" })
end, "jump to prev failed test")

-- Force terminate test
map("n", "<leader>ts", ":lua require('neotest').run.stop()<CR>", "force terminate tests");

map("n", "<leader>u", ":UndotreeToggle<CR>", "toggle undotree")

-- Ensure the required plugins are installed: telescope.nvim and harpoon
local harpoon = require("harpoon")
local conf = require("telescope.config").values

-- Define the toggle function
local function harpoon_toggle(harpoon_files)
  local make_finder = function()
    local paths = {}
    for _, item in ipairs(harpoon_files.items) do
      table.insert(paths, item.value)
    end

    return require("telescope.finders").new_table({
      results = paths,
    })
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = make_finder(),
      previewer = conf.file_previewer({}),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_buffer_number, map_func)
        map_func("i", "<C-d>", function()
          local state = require("telescope.actions.state")
          local selected_entry = state.get_selected_entry()
          local current_picker = state.get_current_picker(prompt_buffer_number)

          -- Remove the selected entry from the Harpoon marks
          harpoon:list():removeAt(selected_entry.index)
          current_picker:refresh(make_finder())
        end)
        return true
      end,
    })
    :find()
end

-- Export the function globally so it can be used in mappings
_G.harpoon_toggle = harpoon_toggle
