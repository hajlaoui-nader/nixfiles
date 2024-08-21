-- Set variable so other plugins can register mappings
local wk = require("which-key")

-- Set up which-key
wk.setup({})

wk.add({
	mode = "n",
	{ "<leader><F5>", "<cmd>UndotreeToggle<CR>", desc = "toggle undo tree" },
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
