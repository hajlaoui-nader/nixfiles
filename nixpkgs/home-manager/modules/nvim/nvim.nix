{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim # theme
      telescope-nvim # fuzzy finder
      which-key-nvim # keybindings
      nvim-tree-lua # file tree
      gitsigns-nvim # git signs
      nvim-cmp # autocompletion
      cmp-buffer
      cmp-vsnip
      cmp-path
      cmp-treesitter
      vim-vsnip
      nvim-autopairs # auto pairs
      nerdcommenter # comments
      nvim-web-devicons # icons
      glow-nvim # markdown preview
      lualine-nvim # statusline
    ];

    # extraConfig = "lua << EOF\n" + builtins.readFile ./init.lua + "\nEOF";

    extraConfig = ''
      lua << EOF
    '' + (builtins.concatStringsSep "\n" [
      (builtins.readFile ./basic.lua)
      (builtins.readFile ./arrows.lua)
      (builtins.readFile ./theme.lua)
      (builtins.readFile ./which-key.lua)
      (builtins.readFile ./telescope.lua)
      (builtins.readFile ./filetree.lua)
      (builtins.readFile ./gitsigns.lua)
      (builtins.readFile ./autopairs.lua)
      (builtins.readFile ./completion.lua)
      (builtins.readFile ./comments.lua)
      (builtins.readFile ./markdown.lua)
      (builtins.readFile ./statusline.lua)
    ]) + ''

      EOF'';
  };

}
