local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
  print("lazy.nvim installed!")
end

-- Set runtimepath to include lazy.nvim
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
    {
        'nvimdev/lspsaga.nvim',
        event = 'LspAttach', -- Lazy load only when LSP attaches
        config = function()
            require('lspsaga').setup({})
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter', -- optional
            'nvim-tree/nvim-web-devicons',     -- optional
        },
    },
    {
        "neovim/nvim-lspconfig",                 -- Core LSP configuration
        dependencies = {
            "williamboman/mason.nvim",           -- Package manager for LSP servers
            "williamboman/mason-lspconfig.nvim", -- Integration between Mason and nvim-lspconfig
            "nvimtools/none-ls.nvim",            -- For linting and formatting
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()
            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({
                    })
                end,
            })
            require("null-ls").setup({
                sources = {
                    require("null-ls").builtins.formatting.prettier, -- Prettier for formatting
                    require("null-ls").builtins.formatting.black.with({
                        extra_args = { "--line-length", "79" },      -- set line length to 79
                    }),
                },
            })
        end,
    },

    -- Completion plugins
    {
        "hrsh7th/nvim-cmp",                 -- Core completion plugin
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",         -- LSP completion source
            "hrsh7th/cmp-buffer",           -- Buffer completion source
            "hrsh7th/cmp-path",             -- Path completion source
            "hrsh7th/cmp-cmdline",          -- Cmdline completion source
            "hrsh7th/cmp-vsnip",            -- Vsnip completion source
            "hrsh7th/vim-vsnip",            -- Snippet engine
            "rafamadriz/friendly-snippets", -- Predefined snippets
        },
    },

    -- Snippets
    {
        "rafamadriz/friendly-snippets",
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate", -- Automatically update parsers
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "python", "javascript" }, -- Add languages you want
                highlight = {
                    enable = true,                                    -- Enable syntax highlighting
                },
                incremental_selection = {
                    enable = true, -- Enable incremental selection
                },
                indent = {
                    enable = true, -- Enable auto-indentation
                },
            })
        end,
    },

    -- Treesitter Playground
    {
        "nvim-treesitter/playground",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "bash", "json", "lua", "python" }, -- Add more languages as needed
                sync_install = false,                                   -- Install parsers asynchronously (non-blocking)
                ignore_install = { "javascript" },                      -- Ignore installing the javascript parser
                auto_install = true,                                    -- Automatically install missing parsers when opening a buffer
                modules = {},
                highlight = {
                    enable = true, -- Enable syntax highlighting
                },
                playground = {
                    enable = true, -- Enable the playground module
                },
            })
        end,
    },

    -- Treesitter Context
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup({
                enable = true,   -- Enable context
                throttle = true, -- Throttle updates (improves performance)
                max_lines = 0,   -- How many lines the context should span (0 = no limit)
                patterns = {     -- Match patterns to show context for specific filetypes
                    default = {
                        "class",
                        "function",
                        "method",
                    },
                },
            })
        end,
    },

    -- Telescope for fuzzy finding
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "Telescope", -- Lazy-load on `:Telescope` command
        config = function()
            require("telescope").setup()
            require("telescope").load_extension("harpoon") -- Load Harpoon extension for Telescope
        end,
    },

    -- Navigation and UI enhancements
    {
        'alexghergh/nvim-tmux-navigation',
        config = function()
            local nvim_tmux_nav = require('nvim-tmux-navigation')

            nvim_tmux_nav.setup {
                disable_when_zoomed = true -- defaults to false
            }
        end
    },
    { "catppuccin/nvim", name = "catppuccin" }, -- Rename to avoid conflicts

    -- Git Plugins
    {
        "tpope/vim-fugitive",
        lazy = false, -- Load immediately
    },
    {
        "junegunn/gv.vim",
        lazy = false, -- Load immediately
    },

    -- Miscellaneous Plugins
    {
        "mbbill/undotree",
        lazy = false, -- Load immediately
    },
    {
        "mtdl9/vim-log-highlighting",
        lazy = false, -- Load immediately
    },
    {
        "chrisbra/csv.vim",
        lazy = false, -- Load immediately
    },
    {
        "tpope/vim-commentary",
        lazy = false, -- Load immediately
    },

    -- Indentation Guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {},
    },

    -- Neotest and dependencies
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({
                    }),
                    output_panel = {
                        open = 'botright vsplit | vertical resize 80'
                    }
                },
            })
        end,
    },

    -- Harpoon - handle file marks
    {
        "ThePrimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
        config = function()
            require("harpoon").setup({
                global_settings = {
                    save_on_toggle = false,
                    save_on_change = true,
                    enter_on_sendcmd = false,
                    tmux_autoclose_windows = false,
                    excluded_filetypes = { "harpoon" },
                    mark_branch = true,
                    tabline = false,
                    tabline_prefix = "   ",
                    tabline_suffix = "   ",
                },
            })
        end,
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- Add your configuration for Noice.nvim here
            lsp = {
                override = {
                    -- override markdown rendering for Neovim LSP
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                bottom_search = true,         -- use a classic bottom command-line for search
                command_palette = true,       -- position the command palette at the top
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false,           -- enable input dialog for incremental renaming
                lsp_doc_border = false,       -- add a border to hover docs and signature help
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },
    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({
                background_colour = "#000000", -- Replace with your desired background color
            })
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "folke/noice.nvim", "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "gruvbox", -- Change to your preferred theme
                    section_separators = { "", "" }, -- Optional: section separators
                    component_separators = { "", "" }, -- Optional: component separators
                },
                sections = {
                    lualine_a = { "mode" },     -- Shows Neovim mode (e.g., NORMAL, INSERT)
                    lualine_b = { "branch" },   -- Shows current Git branch
                    lualine_c = { "filename" }, -- Shows current file name
                    lualine_x = {
                        {
                            require("noice").api.statusline.mode.get,        -- Get current mode from Noice
                            cond = require("noice").api.statusline.mode.has, -- Display only if Noice has a mode
                            color = { fg = "#ff9e64" },                      -- Set custom foreground color
                        },
                        "encoding",                                          -- Shows file encoding
                        "filetype",                                          -- Shows file type
                    },
                    lualine_y = { "progress" },                              -- Shows file progress (percentage)
                    lualine_z = { "location" },                              -- Shows cursor location (line:column)
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                extensions = {},
            })
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",       -- Required dependency
            "nvim-tree/nvim-web-devicons", -- Optional dependency (for file icons)
            "MunifTanjim/nui.nvim",        -- UI components
        },
        config = function()
            require("neo-tree").setup({
                -- Add your configuration options here
                filesystem = {
                    follow_current_file = true,
                    filtered_items = {
                        visible = true,
                        show_hidden_count = true,
                        hide_dotfiles = false,   -- Show dotfiles
                        hide_gitignored = false, -- Show gitignored files
                    },
                },
            })
        end,
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            -- { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },
    {
        "akinsho/bufferline.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons", -- Optional, for file icons
        },
        config = function()
            require("bufferline").setup({
                options = {
                    mode = "buffers",
                    numbers = "buffer_id", -- Use buffer ID for numbering
                    close_command = "bdelete! %d", -- Command to close buffers
                    right_mouse_command = "bdelete! %d", -- Close buffer on right-click
                    left_mouse_command = "buffer %d", -- Go to buffer on left-click
                    middle_mouse_command = nil, -- Disable middle mouse click
                    indicator = {
                        icon = '▎', -- Icon for the current buffer
                        style = 'icon', -- Use icon style for the indicator
                    },
                    buffer_close_icon = ' ', -- Icon for closing a buffer
                    modified_icon = '●', -- Icon for modified buffers
                    close_icon = ' ', -- Icon for closing the tabline
                    separator_style = "slant", -- Set separator style (e.g., "slant", "thin", "thick")
                    always_show_bufferline = true, -- Always show the bufferline
                    offsets = {
                        {
                            filetype = "neo-tree",
                            text = "File Explorer",
                            highlight = "Directory",
                            separator = true,
                        },
                        {
                            filetype = "undotree", -- Offset for Undotree
                            text = "Undo History", -- Label for the Undotree panel
                            text_align = "center", -- Align text to the center
                            separator = true,      -- Add a separator
                        },
                        {
                            filetype = "neotest-summary",
                            text = "Test Summary",
                            text_align = "center",
                            separator = true,
                        },
                    },
                },
            })
        end,
    },
    {
        "sindrets/diffview.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim", -- Required dependency
        },
        config = function()
            require("diffview").setup({
                enhanced_diff_hl = true, -- Enable enhanced highlighting for diffs
                use_icons = true,        -- Requires nvim-web-devicons if set to true
                view = {
                    merge_tool = {
                        layout = "diff3_mixed",     -- Layout for merge conflicts
                        disable_diagnostics = true, -- Disable diagnostics in merge view
                    },
                },
                keymaps = {
                    view = {
                        -- ["q"] = "<cmd>DiffviewClose<CR>", -- Close Diffview
                    },
                    file_panel = {
                        ["j"] = "next_entry", -- Move to the next file
                        ["k"] = "prev_entry", -- Move to the previous file
                    },
                    file_history_panel = {
                        -- ["q"] = "<cmd>DiffviewClose<CR>", -- Close Diffview
                    },
                },
            })
        end,
    },
    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup({
                -- Configuration options (optional)
            })
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = "│" },
                    change       = { text = "│" },
                    delete       = { text = "_" },
                    topdelete    = { text = "‾" },
                    changedelete = { text = "~" },
                },
                current_line_blame = true, -- Show blame info for the current line
                current_line_blame_opts = {
                    delay = 1000,          -- Delay before blame info appears
                    virt_text_pos = "eol", -- Display blame text at the end of the line
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    -- Keybindings for gitsigns
                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map("n", "]c", function()
                        if vim.wo.diff then
                            return "]c"
                        end
                        vim.schedule(function()
                            gs.next_hunk()
                        end)
                        return "<Ignore>"
                    end, { desc = "Next Git hunk" })

                    map("n", "[c", function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(function()
                            gs.prev_hunk()
                        end)
                        return "<Ignore>"
                    end, { desc = "Previous Git hunk" })

                    -- Actions
                    map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>",
                        { desc = "Stage hunk" })
                    map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>",
                        { desc = "Reset hunk" })
                    map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
                    map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
                    map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
                    map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
                    map("n", "<leader>hb", function()
                        gs.blame_line({ full = true })
                    end, { desc = "Blame line" })
                    map("n", "<leader>tb", gs.toggle_current_line_blame,
                        { desc = "Toggle current line blame" })
                    map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
                    map("n", "<leader>hD", function()
                        gs.diffthis("~")
                    end, { desc = "Diff this (against HEAD)" })
                    map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })

                    -- Text object
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>",
                        { desc = "Select Git hunk" })
                end,
            })
        end,
    },


    {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup({
                -- Add your configuration here
                plugins = {
                    marks = true,       -- shows a list of your marks on ' and `
                    registers = true,   -- shows your registers on " in normal or <C-r> in insert mode
                    spelling = {
                        enabled = true, -- enable when using z= to select spelling suggestions
                    },
                },
                layout = {
                    spacing = 6, -- spacing between columns
                },
            })
        end,
    },
    {
        'chentoast/marks.nvim',
        config = function()
            require('marks').setup {
                -- Configuration options for marks.nvim
                default_mappings = true, -- Enable default key mappings
                builtin_marks = { ".", "<", ">", "^" }, -- Built-in marks to enable
                cyclic = true, -- Enable cyclic navigation
                force_write_shada = true, -- Ensure marks persist to shada
                refresh_interval = 250, -- Refresh interval for the signs (in ms)
                sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
                excluded_filetypes = {}, -- Filetypes to exclude from marks.nvim
                bookmark_0 = {
                    sign = "⚑", -- General flag/important
                    virt_text = "Important",
                    annotate = false, -- Disable annotation
                },
                bookmark_1 = {
                    sign = "🚧", -- In progress
                    virt_text = "In Progress",
                    annotate = true,
                },
                bookmark_2 = {
                    sign = "🐞", -- Bug
                    virt_text = "Bug",
                    annotate = true,
                },
                bookmark_3 = {
                    sign = "🔍", -- In review
                    virt_text = "In Review",
                    annotate = false,
                },
            }
        end,
    },
    {
        'tadaa/vimade',
        opts = {
            recipe = { 'minimalist', { animate = true } },
            ncmode = 'windows',
            fadelevel = 0.4, -- any value between 0 and 1. 0 is hidden and 1 is opaque.
            basebg = '',
            blocklist = {
                default = {
                    highlights = {
                        laststatus_3 = function(win, active)
                            if vim.go.laststatus == 3 then
                                return 'StatusLine'
                            end
                        end,
                        'TabLineSel',
                        'Pmenu',
                        'PmenuSel',
                        'PmenuKind',
                        'PmenuKindSel',
                        'PmenuExtra',
                        'PmenuExtraSel',
                        'PmenuSbar',
                        'PmenuThumb',
                        -- Lua patterns are supported, just put the text between / symbols:
                        -- '/^StatusLine.*/' -- will match any highlight starting with "StatusLine"
                    },
                    buf_opts = { buftype = { 'prompt' } },
                    buf_name = {
                        -- Block Mason buffer names (use Lua patterns or exact matches).
                        '/^mason.*/' -- Matches any buffer name starting with "mason".
                    },
                    -- buf_vars = { variable = {'match1', 'match2'} },
                    -- win_opts = { option = {'match1', 'match2' } },
                    -- win_vars = { variable = {'match1', 'match2'} },
                    -- win_type = {'name1','name2', name3'},
                    -- win_config = { variable = {'match1', 'match2'} },
                },
                default_block_floats = function(win, active)
                    return win.win_config.relative ~= '' and
                        (win ~= active or win.buf_opts.buftype == 'terminal') and true or false
                end,
            },
            link = {},
            groupdiff = true,        -- links diffs so that they style together
            groupscrollbind = false, -- link scrollbound windows so that they style together.
            enablefocusfading = false,
            checkinterval = 1000,
            usecursorhold = false,
            nohlcheck = true,
            focus = {
                providers = {
                    filetypes = {
                        default = {
                            -- If you use mini.indentscope, snacks.indent, or hlchunk, you can also highlight
                            -- using the same indent scope!
                            -- {'snacks', {}},
                            -- {'mini', {}},
                            -- {'hlchunk', {}},
                            { 'treesitter', {
                                min_node_size = 2,
                                min_size = 1,
                                max_size = 0,
                                -- exclude types either too large and/or mundane
                                exclude = {
                                    'script_file',
                                    'stream',
                                    'document',
                                    'source_file',
                                    'translation_unit',
                                    'chunk',
                                    'module',
                                    'stylesheet',
                                    'statement_block',
                                    'block',
                                    'pair',
                                    'program',
                                    'switch_case',
                                    'catch_clause',
                                    'finally_clause',
                                    'property_signature',
                                    'dictionary',
                                    'assignment',
                                    'expression_statement',
                                    'compound_statement',
                                }
                            } },
                            -- if treesitter fails or there isn't a good match, fallback to blanks
                            -- (similar to limelight)
                            { 'blanks', {
                                min_size = 1,
                                max_size = '35%'
                            } },
                            -- if blanks fails to find a good match, fallback to static 35%
                            { 'static', {
                                size = '35%'
                            } },
                        },
                    },
                }
            },
        }
    },
    {
        "vimpostor/vim-tpipeline",
    },
})

-- Setup nvim-cmp
local cmp = require 'cmp'
local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
    }, {
        { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' },
    }, {
        { name = 'buffer' },
    })
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path', option = { trailing_slash = true } }
    }, {
        { name = 'cmdline' }
    })
})
