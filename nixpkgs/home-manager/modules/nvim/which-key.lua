-- Set variable so other plugins can register mappings
local wk = require("which-key")

 -- Set up which-key
 require("which-key").setup {}

 wk.register({
    ["<F5>"] = {"<cmd>UndotreeToggle<CR>", "Toggle UndoTree"},
}, { prefix = "<leader>" })

