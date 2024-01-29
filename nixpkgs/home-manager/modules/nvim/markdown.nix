{ pkgs, ... }: {
  markdown = ''
        require('glow').setup({
          border = "shadow", 
          glow_path="${pkgs.glow}/bin/glow",
          pager = false,
          width = 120,
        })

      vim.cmd [[ 
          autocmd FileType markdown noremap <leader>p :Glow<CR> 
        ]]
  '';
}

