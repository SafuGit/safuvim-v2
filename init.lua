---@diagnostic disable: undefined-global
-- *LAZY SETUP

-- Bootstrap lazy.nvim
vim.opt.termguicolors = true
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{
			"folke/which-key.nvim",
			-- event = "VeryLazy",
			opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			},
			keys = {
				{
					"<leader>?n",
					function()
						require("which-key").show({ global = true })
					end,
					desc = "Show all Keymaps",
				},
				{
					"<leader>?v",
					function()
						require("which-key").show({ mode = "v", global = true })
					end,
					desc = "Show all Visual Mode Keymaps",
				},
			},
		},

		{
			'nvim-telescope/telescope.nvim',
			tag = '0.1.8',
			dependencies = { 'nvim-lua/plenary.nvim' }
		},

		{
			"nvim-telescope/telescope-file-browser.nvim",
			dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
		},

		-- {
		--     'IogaMaster/neocord',
		--     event = "VeryLazy"
		-- },

		{ "nvim-tree/nvim-web-devicons", opts = {} },

		{ 'echasnovski/mini.icons',      version = '*' },

		{
			"goolord/alpha-nvim",
			-- dependencies = { 'echasnovski/mini.icons' },
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			config = function()
				require('alpha').setup(require('startup').config)
			end
		},

		{
			-- Calls `require('slimline').setup({})`
			"sschleemilch/slimline.nvim",
			dependencies = { "lewis6991/gitsigns.nvim", "echasnovski/mini.icons" },
			opts = {
				spaces = {
					components = "",
					left = "",
					right = "",
				},
				sep = {
					hide = {
						first = true,
						last = true,
					},
					left = "",
					right = "",
				},
				filetype = {
					icon = true,
					name = true,
				},
				components = {
					left = {
						"mode",
						"path",
						"git"
					},
					right = {
						"diagnostics",
						"filetype_lsp",
						"progress"
					},
				}
			}
		},

		{
			'projekt0n/github-nvim-theme',
			name = 'github-theme',
			lazy = false,      -- make sure we load this during startup if it is your main colorscheme
			priority = 1000,   -- make sure to load this before all the other start plugins
			config = function()
				require('github-theme').setup({

				})

				vim.cmd('colorscheme github_dark_default')
			end,
		},

		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons",   -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
				-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
			}
		},

		{
			"folke/edgy.nvim",
			event = "VeryLazy",
		},

		{ 'famiu/bufdelete.nvim' },

		{ 'akinsho/bufferline.nvim',   version = "*", dependencies = 'nvim-tree/nvim-web-devicons' },

		{ 'xiyaowong/transparent.nvim' },

		{
			"ahmedkhalf/project.nvim",
			config = function()
				require("project_nvim").setup({
					manual_mode = false,   -- Auto-detect projects
					detection_methods = { "lsp", "pattern" },
					patterns = { ".git", "Makefile", "package.json", "*.sln", "Cargo.toml", "lazy-lock.json", ".venv" },
					show_hidden = true,
					silent_chdir = false,   -- Show messages when switching projects
				})
				require("telescope").load_extension("projects")
			end,
			dependencies = { "nvim-telescope/telescope.nvim" }
		},

		{
			'vyfor/cord.nvim',
			build = ':Cord update',
			-- opts = {}
		},

		{ 'MunifTanjim/nui.nvim' },

		-- Mason for managing LSP servers
		{
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup({})
			end,
		},

		-- mason-lspconfig for automatically configuring LSP servers
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = { "neovim/nvim-lspconfig" },
			config = function()
				require("mason-lspconfig").setup({
					ensure_installed = { "pyright", "ts_ls", "lua_ls", "html", "rust_analyzer", "dockerls" },     -- Add the LSPs you need
					automatic_installation = true,                                   -- Automatically install missing LSP servers
				})
			end,
		},

		-- nvim-lspconfig for configuring the LSP servers
		{
			"neovim/nvim-lspconfig",
			config = function()
				-- mason-lspconfig will automatically configure these servers
				require("lspconfig").html.setup({})
				require("lspconfig").pyright.setup({})
				require("lspconfig").ts_ls.setup({})
				require("lspconfig").lua_ls.setup({})
                require("lspconfig").rust_analyzer.setup({})
                require("lspconfig").dockerls.setup({})
			end,
		},

		-- nvim-cmp for autocompletion
		{
			"hrsh7th/nvim-cmp",
			dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path" },
			config = function()
				local cmp = require("cmp")
				cmp.setup({
					sources = {
						{ name = "nvim_lsp" },     -- Use LSP for completion
						{ name = "buffer" },       -- Use buffer contents for completion
						{ name = "path" },         -- Use filesystem paths for completion
                        { name = "codeium" },
					},
				})
			end,
		},

		-- Other dependencies (optional)
		{
			"hrsh7th/cmp-nvim-lsp",
			config = function() end,     -- Required for nvim-cmp to work with LSP
		},

        {
            'aurum77/live-server.nvim',
            build = function ()
                require"live_server.util".install()
            end,
            cmd = { "LiveServer", "LiveServerStart", "LiveServerStop" },
        },

        {"https://git.sr.ht/~whynothugo/lsp_lines.nvim",},

        {'lewis6991/gitsigns.nvim'},

        {
            'SuperBo/fugit2.nvim',
            build = false,
            opts = {
              width = 100,
	      height = "90%"
            },
            dependencies = {
              'MunifTanjim/nui.nvim',
              'nvim-tree/nvim-web-devicons',
              'nvim-lua/plenary.nvim',
              {
                'chrisgrieser/nvim-tinygit', -- optional: for Github PR view
                dependencies = { 'stevearc/dressing.nvim' }
              },
            },
            cmd = { 'Fugit2', 'Fugit2Diff', 'Fugit2Graph' },
            keys = {
              { '<leader>F', mode = 'n', '<cmd>Fugit2<cr>' }
            },
        },

        -- Lua
        {
            "folke/zen-mode.nvim",
            opts = {
                on_open = function(win)
                    vim.opt.laststatus = 0 -- Hide statusline
                end,
                on_close = function()
                    vim.opt.laststatus = 3 -- Restore statusline
                end
            }
        },

        {
            'windwp/nvim-autopairs',
            event = "InsertEnter",
            config = true
            -- use opts = {} for passing setup options
            -- this is equivalent to setup({}) function
        },

        {'wellle/context.vim'},

        {'gennaro-tedesco/nvim-commaround'},

        {
            "kawre/leetcode.nvim",
            dependencies = {
                "nvim-telescope/telescope.nvim",
                -- "ibhagwan/fzf-lua",
                "nvim-lua/plenary.nvim",
                "MunifTanjim/nui.nvim",
            },
            opts = {
                plugins = {
                    non_standalone = true,
                }
            },
            cmd = "Leet",
        },
	},

	install = { colorscheme = { "github_dark_default" } },
	checker = { enabled = true },
})

vim.g.toggle_commaround = 'gcc'

-- *GIT CONFIG
require('gitsigns').setup({
    current_line_blame = true,
})

-- *LSP CONFIG
require("lsp_lines").setup()
vim.diagnostic.config({
    virtual_text = false,  -- Show inline diagnostics
    signs = true,         -- Show signs in the gutter
    underline = true,     -- Underline the text with errors
    update_in_insert = false,  -- Disable updates while in insert mode for performance
  })

-- *TERMINAL
vim.cmd("set shell=powershell.exe")

-- *STATUSLINE FIX
vim.opt.laststatus = 3

-- *NEOVIDE CONFIG
if vim.g.neovide then
	vim.g.neovide_opacity = 0.9
	vim.g.neovide_normal_opacity = 0.9
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0
	vim.g.neovide_floating_shadow = true
	vim.g.neovide_floating_z_height = 10
	vim.g.neovide_light_angle_degrees = 45
	vim.g.neovide_light_radius = 5

	vim.g.neovide_padding_top = 0
	vim.g.neovide_padding_bottom = 0
	vim.g.neovide_padding_right = 0
	vim.g.neovide_padding_left = 0
end


-- *BUFFERLINE CONFIG

vim.opt.termguicolors = true
require("bufferline").setup({
	options = {
		mode = "buffers",
		themable = true,
		separator_style = "slope",
		always_show_bufferline = false,   -- Hide bufferline when only one buffer is open
		--   diagnostics = "nvim_lsp",
		persist_buffer_sort = true,
		offsets = {
			{
				filetype = "neo-tree",
				text = "File Explorer",
				highlight = "Directory",
				text_align = "center",
				separator = true   -- Adds a separator between Neotree and bufferline
			}
		}
	},
})


-- *NEOTREE CONFIG
require("neo-tree").setup({
	sources = { "filesystem", "buffers" },
	source_selector = {
		winbar = true,   -- Adds a tab switcher in the Neo-tree window
		statusline = false,
	},
	default_component_configs = {
		indent = { padding = 0, },
		icon = { folder_closed = "", folder_open = "", },
	},
	window = {
		position = "left",
		width = 35,   -- Adjust sidebar width
	},
	filesystem = {
		follow_current_file = true,
		filtered_items = { hide_dotfiles = false, hide_gitignored = false, },
	},
	buffers = {
		follow_current_file = true,
		show_unloaded = true,
	},
})

-- Custom function to show buffers in a vertical style
function _G.Tabline()
	local s = " "
	for i = 1, vim.fn.tabpagenr("$") do
		local hl = i == vim.fn.tabpagenr() and "%#TabLineSel#" or "%#TabLine#"
		s = s .. hl .. " " .. i .. " "
	end
	return s
end

-- *KEYBINDS

local wk = require("which-key")

wk.register({
	["<C-c>"] = { '"+y', "Copy (Yank) to Clipboard" },
	["<C-v>"] = { '"+p', "Paste from Clipboard" },
}, { mode = "v" }) -- 'v' for visual mode

wk.register({
	["<C-z>"] = { 'u', "Undo (Ctrl-Z)" },
	["<C-y>"] = { '<C-r>', "Redo (Ctrl-Y)" },
	["<space>fb"] = { ':Telescope file_browser path=D:/Coding<CR>', "Telescope File Browser" },
	["<C-a>"] = { "ggVG", "Select All" },
	["<C-s>"] = { ":w<CR>", "Save File" },
	["<C-t>"] = { ":Neotree toggle<CR>", "Open Explorer" },
	["<space>t"] = { ":Neotree focus<CR>", "Focus on Explorer" },
	["<space>h"] = { ":Alpha<CR>", "Go to Home" },
	["<C-b>"] = { ":Telescope buffers<CR>", "Telescope Buffers" },
	["<space>cd"] = { ":Telescope file_browser path=%:p:h select_buffer=true<CR>", "cd To current buffer directory" },
	["<space>fr"] = { ":Telescope projects<CR>", "Open Recent Projects" },
	["<space>fc"] = { ":Telescope file_browser path=C:/Users/Safu/AppData/Local/nvim<CR>", "Open Config" },
	["<C-m>"] = { ":luafile C:/Users/Safu/AppData/Local/nvim/lua/menu.lua<CR>", "Open Menu" },
}, { mode = "n" })

local cmp = require('cmp')

wk.register({
    ["<Tab>"] = {cmp.mapping.select_next_item(), "Select next item"},
    ["`"] = {cmp.mapping.select_prev_item(), "Select previous item"},
}, {mode = "i"})

vim.keymap.set("", "<C-z>", "<Nop>", { noremap = true, silent = true }) -- Disable suspend
