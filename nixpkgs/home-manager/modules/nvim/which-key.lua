-- Set variable so other plugins can register mappings
local wk = require("which-key")

-- Set up which-key
require("which-key").setup({})

wk.register({
	{ "<leader>", "<leader><F5>", desc = "<cmd>UndotreeToggle<CR>" },
}, { prefix = "<leader>" })

-- Register gitsigns keybindings with descriptions
wk.register({
	{
		{ "<leader>", "<leader>gr", desc = "<cmd>gitsigns reset_hunk<cr>" },
		{ "<leader>", "<leader>gr", desc = "<cmd>gitsigns reset_buffer<cr>" },
		{ "<leader>", "<leader>gd", desc = "<cmd>lua require'gitsigns'.diffthis('~')<cr>" },
		{ "<leader>", "<leader>gs", desc = "<cmd>gitsigns stage_buffer<cr>" },
		{ "<leader>", "<leader>gd", desc = "<cmd>gitsigns diffthis<cr>" },
		{ "<leader>", "<leader>gb", desc = "<cmd>lua require'gitsigns'.blame_line{full=true}<cr>" },
		{ "<leader>", "<leader>gn", desc = "<cmd>gitsigns next_hunk<cr>" },
		{ "<leader>", group = "gitsigns" },
		{ "<leader>", "<leader>gts", desc = "<cmd>gitsigns toggle_signs<cr>" },
		{ "<leader>", "<leader>gs", desc = "<cmd>gitsigns stage_hunk<cr>" },
		{ "<leader>", "<leader>gu", desc = "<cmd>gitsigns undo_stage_hunk<cr>" },
		{ "<leader>", group = "toggle" },
		{ "<leader>", "<leader>gtd", desc = "<cmd>gitsigns toggle_deleted<cr>" },
		{ "<leader>", "<leader>gtb", desc = "<cmd>gitsigns toggle_current_line_blame<cr>" },
		{ "<leader>", "<leader>gp", desc = "<cmd>gitsigns preview_hunk<cr>" },
	},
}, { prefix = "<leader>" })
