local wk = require("which-key")
require("gitsigns").setup({
	--keymaps = {
	--noremap = true,

	--['n <leader>gn'] = { expr = true, "&diff ? \'\' : '<cmd>Gitsigns next_hunk<CR>'"},
	--['n <leader>gp'] = { expr = true, "&diff ? \'\' : '<cmd>Gitsigns prev_hunk<CR>'"},

	--['n <leader>gs'] = '<cmd>Gitsigns stage_hunk<CR>',
	--['v <leader>gs'] = ':Gitsigns stage_hunk<CR>',
	--['n <leader>gu'] = '<cmd>Gitsigns undo_stage_hunk<CR>',
	--['n <leader>gr'] = '<cmd>Gitsigns reset_hunk<CR>',
	--['v <leader>gr'] = ':Gitsigns reset_hunk<CR>',
	--['n <leader>gR'] = '<cmd>Gitsigns reset_buffer<CR>',
	--['n <leader>gb'] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
	--['n <leader>gS'] = '<cmd>Gitsigns stage_buffer<CR>',
	--['n <leader>gU'] = '<cmd>Gitsigns reset_buffer_index<CR>',
	--['n <leader>gts'] = ':Gitsigns toggle_signs<CR>',
	--['n <leader>gtn'] = ':Gitsigns toggle_numhl<CR>',
	--['n <leader>gtl'] = ':Gitsigns toggle_linehl<CR>',
	--['n <leader>gtw'] = ':Gitsigns toggle_word_diff<CR>',

	---- Text objects
	--['o ih'] = ':<C-U>Gitsigns select_hunk<CR>',
	--['x ih'] = ':<C-U>Gitsigns select_hunk<CR>'
	--},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		local function nextHunk()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end

		local function prevHunk()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end
		wk.add({
			mode = "n",
			{ "<leader>g", group = "gitsigns" },
			---- blame gb
			{ "<leader>gb", "<cmd>lua require'gitsigns'.blame_line{full=true}<cr>", desc = "blame (full)" },
			-- toggle current line blame
			{
				"<leader>gtb",
				"<cmd>Gitsigns toggle_current_line_blame<cr>",
				desc = "toggle current line blame",
			},
			-- toggle deleted
			{ "<leader>gtd", "<cmd>Gitsigns toggle_deleted<cr>", desc = "toggle deleted" },
			-- diff this
			{ "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "diff current file" },
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
			{ "<leader>ghn", nextHunk, desc = "next hunk" },
			{ "<leader>ghp", prevHunk, desc = "prev hunk" },
			{ "<leader>ghr", "<cmd>Gitsigns reset_hunk<cr>", desc = "reset hunk" },

			{ "<leader>ghs", "<cmd>Gitsigns stage_hunk<cr>", desc = "stage hunk" },
			-- undo stage hunk
			{ "<leader>ghu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "undo stage hunk" },
		})

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
})
