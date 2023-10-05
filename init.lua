-- ===============================
-- Initial config
-- ===============================
vim.scriptencoding = 'utf-8'

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.wo.number = true

vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.autoindent = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.showmatch = true

-- ===============================
-- Lazy
-- ===============================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate"
	},

	-- Adjust shiftwidth and expandtab
	"tpope/vim-sleuth",

	-- LSP configuration
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Mason
			{
				'williamboman/mason.nvim',
				config = true
			},

			-- Mason with LSP Config
			'williamboman/mason-lspconfig.nvim',

			-- Status updates for LSP when installing
			{ 
				"j-hui/fidget.nvim",
				tag = "legacy",
				opts = {}
			},
			
			-- Signature help
			{
				"folke/neodev.nvim",
				opts = {} 
			},
		},
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { 
			"nvim-lua/plenary.nvim",

			-- Fuzzy Finder
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make"
			}
		},
	},

	-- Git Signs
	{
    		"lewis6991/gitsigns.nvim",
    		opts = {
      			signs = {
      				add = { text = '+' },
      			  	change = { text = '~' },
      			  	delete = { text = '_' },
      			  	topdelete = { text = '‾' },
      			  	changedelete = { text = '~' },
      			},	
      			on_attach = function(bufnr)
        			vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        			local gs = package.loaded.gitsigns
        			vim.keymap.set({'n', 'v'}, ']c', function()
        				if vim.wo.diff then return ']c' end
        			  	vim.schedule(function() gs.next_hunk() end)
        			  	return '<Ignore>'
        			end, {expr=true, buffer = bufnr, desc = "Jump to next hunk"})
        			vim.keymap.set({'n', 'v'}, '[c', function()
        			  	if vim.wo.diff then return '[c' end
        			  	vim.schedule(function() gs.prev_hunk() end)
        			  	return '<Ignore>'
        			end, {expr=true, buffer = bufnr, desc = "Jump to previous hunk"})
      			end,
    		},
  	},

	-- Git plugins
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- LSP completion
			"hrsh7th/cmp-nvim-lsp",
			
			-- Snippet engine
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",

			-- User friendly snippets
			"rafamadriz/friendly-snippets",
		}
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = true,
				theme = "tokyonight",
				component_separators = { left = '', right = ''},
				section_separatos = "",
			}
		}
	},

	-- Theme
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},

	-- Pending keybinds
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
  		init = function()
    			vim.o.timeout = true
    			vim.o.timeoutlen = 300
  		end,
	},

	-- Indentation guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {}
	},
	
	-- Powerful comment lines and blocks
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},

})

-- ===============================
-- Theme
-- ===============================
vim.cmd[[colorscheme tokyonight-night]]

-- ===============================
-- Keymaps
-- ===============================
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Telescope
require("telescope").setup {
	defaults = {
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
			},
		},
	},
}

-- Enable telescope with fzf native
pcall(require("telescope").load_extension, "fzf")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
		winblend = 10,
		previewer = false,
	})
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Search [G]it [F]iles" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })

-- Treesitter
vim.defer_fn(function()
	require("nvim-treesitter.configs").setup {
		ensure_installed = {
			"c",
			"c_sharp",
			"cpp",
			"css",
			"go",
			"html",
			"java",
			"javascript",
			"kotlin",
			"lua",
			"php",
			"python",
			"ruby",
			"rust",
			"scss",
			"sql",
			"tsx",
			"typescript",
			"vimdoc",
			"vim",
			"vue",
			"yaml",
			"zig",
		},

		auto_install = false,

		highlight = { enable = true },
		indent = { enable = true },	
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<c-space>",
				node_incremental = "<c-space>",
				scope_incremental = "<c-s>",
				node_decremental = "<M-space>",
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["aa"] = "@parameter.outer",
					["ia"] = "@parameter.inner",
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				}
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]m"] = "@function.outer",
					["]]"] = "@class.outer",
				},
				goto_next_end = {
					["]M"] = "@function.outer",
					["]["] = "@class.outer",
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
					["[["] = "@class.outer",
				},
				goto_previous_end = {
					["[M"] = "@function.outer",
					["[]"] = "@class.outer",
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>a"] = "@parameter.inner",
				},
				swap_previous = {
					["<leader>A"] = "@parameter.inner",
				},
			},
		},
	}
end, 0)

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic list" })

-- Configure LSP
local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end
		
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		
	local builtin = require("telescope.builtin")
	
	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", bultin.lsp_references, "[G]oto [R]eferences")
	nmap("gI", bultin.lsp_implementations, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", bultin.lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", bultin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end

-- Documenting key chains
require("which-key").register({
	["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
	["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
	["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
	["<leader>h"] = { name = "More Git", _ = "which_key_ignore" },
	["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
	["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
	["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
})

-- Install servers to LSP
local servers = {
	csharp_ls = {},
	gopls = {},
	html = {},
	intelephense = {},
	kotlin_language_server = {},
	pyright = {},
	ruby_ls = {},
	rust_analyzer = {},
	tsserver = {},
	zls = {},
	
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}


require("neodev").setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Mason LSP config
local mason_lspconfig = require "mason-lspconfig"

mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
	function(server_name)
		require("lspconfig")[server_name].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
			filetypes = (servers[server_name] or {}).filetypes,
		}
	end
}

-- Configure nvim-cmp
local cmp = require "cmp"
local luasnip = require "luasnip"

require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup {}

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	
	mapping = cmp.mapping.preset.insert {
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete {},
		["<CR>"] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},

	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
}
