require('gitsigns').setup {
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
    map('n', '<leader>gn', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '<leader>gp', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', '<leader>gs', gs.stage_hunk)
    map('n', '<leader>gr', gs.reset_hunk)
    map('v', '<leader>gs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<leader>gr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>gS', gs.stage_buffer)
    map('n', '<leader>gu', gs.undo_stage_hunk)
    map('n', '<leader>gR', gs.reset_buffer)
    map('n', '<leader>gp', gs.preview_hunk)
    map('n', '<leader>gb', function() gs.blame_line{full=true} end)
    map('n', '<leader>gtb', gs.toggle_current_line_blame)
    map('n', '<leader>gd', gs.diffthis)
    map('n', '<leader>gD', function() gs.diffthis('~') end)
    map('n', '<leader>gtd', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
