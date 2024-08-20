-- Set variable so other plugins can register mappings
local wk = require("which-key")

-- Set up which-key
wk.setup({})

wk.add({
	mode = "n",
	{ "<leader><F5>", "<cmd>UndotreeToggle<CR>", desc = "toggle undo tree" },
})
wk.add({
	mode = "n",
	{ "<leader>g", group = "gitsigns" },
	---- blame gb
	{ "<leader>gb", "<cmd>lua require'gitsigns'.blame_line{full=true}<cr>", desc = "blame (full)" },
	-- toggle current line blame
	{
		"<leader>gtb",
		"<cmd>gitsigns toggle_current_line_blame<cr>",
		desc = "toggle current line blame",
	},
	-- toggle deleted
	{ "<leader>gtd", "<cmd>gitsigns toggle_deleted<cr>", desc = "toggle deleted" },
	-- diff this
	{ "<leader>gd", "<cmd>gitsigns diffthis<cr>", desc = "diff current file" },
	-- diff this ~
	{ "<leader>gD", "<cmd>lua require'gitsigns'.diffthis('~')<cr>", desc = "diff file" },
	-- S
	{ "<leader>gs", "<cmd>lua require'gitsigns'.stage_buffer()<cr>", desc = "stage buffer" },
	-- R
	{ "<leader>gr", "<cmd>lua require'gitsigns'.reset_buffer_index()<cr>", desc = "reset buffer" },
})

-- git hunks
wk.add({
	{ "<leader>gh", group = "hunks" },
	{ "<leader>ghn", "<cmd>gitsigns next_hunk<cr>", desc = "next hunk" },
	{ "<leader>ghp", "<cmd>gitsigns prev_hunk<cr>", desc = "prev hunk" },
	{ "<leader>ghr", "<cmd>gitsigns reset_hunk<cr>", desc = "reset hunk" },

	{ "<leader>ghs", "<cmd>gitsigns stage_hunk<cr>", desc = "stage hunk" },
	-- undo stage hunk
	{ "<leader>ghu", "<cmd>gitsigns undo_stage_hunk<cr>", desc = "undo stage hunk" },
})

-- LSP
wk.add({
	mode = "n",
	{ "<leader>l", group = "lsp" },
})

-- Trouble
wk.add({ mode = "n", { "<leader>x", group = "trouble" } })

-- a code action
wk.add({
	mode = "n",
	{ "<leader>a", group = "code action" },
})

-- b buffers
wk.add({ mode = "n", { "<leader>b", group = "buffers" } })

-- c commenter group
wk.add({ mode = "n", { "<leader>c", group = "commenter" } })

-- f telescope
wk.add({ mode = "n", { "<leader>f", group = "telescope" } })

-- s substitute
wk.add({ mode = "n", { "<leader>s", group = "substitute" } })
