require("nvim-treesitter.configs").setup({
	autotag = {
		enable = true,
		disable = {},
	},
	highlight = {
		enable = true,
		disable = {},
	},
	incremental_selection = {
		enable = true,
		disable = {},
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
	indent = {
		enable = false,
		disable = {},
	},
})

require("treesitter-context").setup({
	enable = false,
	max_lines = 0,
})
