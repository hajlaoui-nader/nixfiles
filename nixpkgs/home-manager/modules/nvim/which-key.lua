-- Set variable so other plugins can register mappings
local wk = require("which-key")

 -- Set up which-key
 require("which-key").setup {}

wk.register({
    ["<F5>"] = {"<cmd>UndotreeToggle<CR>", "Toggle UndoTree"},
}, { prefix = "<leader>" })

-- Register gitsigns keybindings with descriptions
--wk.register({
  --g = {
    --name = "Gitsigns", -- Optional group name
    --n = {"<cmd>Gitsigns next_hunk<CR>", "Next Hunk"},
    --p = {"<cmd>Gitsigns prev_hunk<CR>", "Previous Hunk"},
    --s = {"<cmd>Gitsigns stage_hunk<CR>", "Stage Hunk"},
    --r = {"<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk"},
    --S = {"<cmd>Gitsigns stage_buffer<CR>", "Stage Buffer"},
    --u = {"<cmd>Gitsigns undo_stage_hunk<CR>", "Undo Stage Hunk"},
    --R = {"<cmd>Gitsigns reset_buffer<CR>", "Reset Buffer"},
    --b = {"<cmd>lua require'gitsigns'.blame_line{full=true}<CR>", "Blame Line"},
    --tb = {"<cmd>Gitsigns toggle_current_line_blame<CR>", "Toggle Line Blame"},
    --d = {"<cmd>Gitsigns diffthis<CR>", "Diff This"},
    --D = {"<cmd>lua require'gitsigns'.diffthis('~')<CR>", "Diff This ~"},
    --td = {"<cmd>Gitsigns toggle_deleted<CR>", "Toggle Deleted"},
    ---- Text object not necessary to show in which-key
  --}
--}, { prefix = "<leader>" })
