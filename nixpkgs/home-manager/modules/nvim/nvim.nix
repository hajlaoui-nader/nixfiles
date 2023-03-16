{ pkgs, lib, ... }:
let
  lsp = (import ./lsp.nix { inherit pkgs; }).lsp;
  telescope = (import ./telescope.nix { inherit pkgs; }).telescope;
  #vim-plugins = import ./plugins.nix { inherit pkgs lib; };
in
{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      # tokyonight-nvim # theme
      catppuccin-nvim # theme
      onedark-nvim # theme
      telescope-nvim # fuzzy finder
      which-key-nvim # keybindings
      nvim-tree-lua # file tree
      gitsigns-nvim # git signs
      nvim-cmp # autocompletion
      cmp-nvim-lsp
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
      #nvim-treesitter.withAllGrammars
      (nvim-treesitter.withPlugins (
        plugins: with plugins; [
          nix
          c
          python
          lua
          scala
          java
          rust
          go
          bash
          json
          sql
          html
          dockerfile
          scala
          yaml
          markdown
          vim
          gitignore
          hcl
          http
          #(tree-sitter-scala.overrideAttrs
            #(old: {
              #version = "master";
              #src = tree-sitter-scala-master;
            #})
          #)
        ]
      ))
      nvim-treesitter-context # context
      nvim-ts-autotag # auto close tags
      nvim-lightbulb # lightbulb
      lsp_signature-nvim # lsp signature
      vim-nix # File type and syntax highlighting.
      lspkind-nvim # lsp kind
      nvim-code-action-menu # code actions
      trouble-nvim # lsp diagnostics
      nvim-metals # metals
      null-ls-nvim # null-ls
      nvim-lspconfig # lsp config
      hop-nvim
      # TODO: add these back in
      # vim-plugins.nvim-ufo
      # vim-plugins.promise-async
      bufferline-nvim # bufferline
      nvim-cursorline # cursorline
      indent-blankline-nvim # indent lines
      copilot-vim # copilot
    ];

    extraConfig = ''
      lua << EOF
    '' + (builtins.concatStringsSep "\n" [
      (builtins.readFile ./basic.lua)
      (builtins.readFile ./completion.lua)
      lsp
      (builtins.readFile ./filetree.lua)
      (builtins.readFile ./arrows.lua)
      (builtins.readFile ./themes/onedark.lua)
      (builtins.readFile ./which-key.lua)
      (builtins.readFile ./treesitter.lua)
      telescope
      (builtins.readFile ./trouble.lua)
      (builtins.readFile ./metals.lua)
      (builtins.readFile ./gitsigns.lua)
      (builtins.readFile ./autopairs.lua)
      (builtins.readFile ./comments.lua)
      (builtins.readFile ./markdown.lua)
      (builtins.readFile ./statusline.lua)
      (builtins.readFile ./bufferline.lua)
      (builtins.readFile ./visuals.lua)
      (builtins.readFile ./json.lua)
      (builtins.readFile ./hop.lua)
      (builtins.readFile ./copilot.lua)
    ]) + ''

      EOF'';
  };

}
