{ pkgs, lib, ... }: 
  let lsp =  (import ./lsp.nix { inherit pkgs; }).lsp;
  vim-plugins = import ./plugins.nix { inherit pkgs lib; };
in {
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
      nvim-treesitter # treesitter
      nvim-treesitter-context # context
      nvim-ts-autotag # auto close tags
      nvim-lightbulb # lightbulb
      lsp_signature-nvim # lsp signature
      lspsaga-nvim # lsp saga
      lspkind-nvim # lsp kind
      nvim-code-action-menu # code actions
      trouble-nvim # lsp diagnostics
      nvim-metals # metals
      null-ls-nvim # null-ls
      nvim-lspconfig # lsp config
      # TODO: add these back in
      # vim-plugins.nvim-ufo
      # vim-plugins.promise-async
      bufferline-nvim # bufferline
      nvim-cursorline # cursorline
      indent-blankline-nvim # indent lines
    ];

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
      (builtins.readFile ./treesitter.lua)
      lsp
      (builtins.readFile ./bufferline.lua)
      (builtins.readFile ./visuals.lua)
    ]) + ''

      EOF'';
  };

}
