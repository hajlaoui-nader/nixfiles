{ pkgs, unstable, ... }:
let
  lsp = (import ./lsp.nix { inherit pkgs; }).lsp;
  telescope = (import ./telescope.nix { inherit pkgs; }).telescope;
  conform = (import ./formatters.nix { inherit pkgs; }).conform;
  glowMarkdown = (import ./markdown.nix { inherit pkgs; }).markdown;
  gruberDarker = pkgs.vimUtils.buildVimPlugin {
    name = "gruber-darker-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "blazkowolf";
      repo = "gruber-darker.nvim";
      rev = "master"; # You can specify a specific commit or tag here.
      #sha256 = "OftISM/UpLJsNpnZAC9D/CfDueNjUdbCkrotS4vnH6M="; # Replace with the correct hash.
      sha256 = "dMs2gdzhS8DLg6P0+msJ+cYluV9LoXE5cW3rI2i+tus=";
    };
  };
  #vim-plugins = import ./plugins.nix { inherit pkgs lib; };
in
{
  programs.neovim = {
    #package = unstable.neovim;
    enable = true;
    plugins = with pkgs.vimPlugins; [
      # tokyonight-nvim # theme
      catppuccin-nvim # theme
      onedark-nvim # theme
      gruberDarker # theme
      telescope-nvim # fuzzy finder
      telescope-ui-select-nvim # telescope ui
      actions-preview-nvim # code action
      nui-nvim # ui
      nvim-surround # surround
      which-key-nvim # keybindings
      nvim-tree-lua # file tree
      gitsigns-nvim # git signs
      conform-nvim # formatter
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
      mini-nvim # containing mini.icons
      glow-nvim # markdown preview
      lualine-nvim # statusline
      #nvim-treesitter.withAllGrammars
      (nvim-treesitter.withPlugins (
        plugins: with plugins; [
          tsx
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
          dockerfile
          scala
          yaml
          markdown
          vim
          gitignore
          hcl
          http
          terraform
          typescript
          javascript
          html
          css
          scss
          vimdoc
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
      nvim-lspconfig # lsp config
      hop-nvim
      # TODO: add these back in
      # vim-plugins.nvim-ufo
      # vim-plugins.promise-async
      bufferline-nvim # bufferline
      nvim-cursorline # cursorline
      indent-blankline-nvim # indent lines
      copilot-vim # copilot
      # rust
      rust-tools-nvim
      crates-nvim
      # notify 
      nvim-notify
      # undotree
      undotree
      # references
      vim-illuminate
      # neoclip
      nvim-neoclip-lua
      # fugitive
      vim-fugitive
      # db
      vim-dadbod
      # db-ui
      vim-dadbod-ui
      # db-completion
      vim-dadbod-completion

    ];

    extraConfig = ''
      lua << EOF
    '' + (builtins.concatStringsSep "\n" [
      (builtins.readFile ./which-key.lua)
      (builtins.readFile ./basic.lua)
      (builtins.readFile ./completion.lua)
      conform
      lsp
      (builtins.readFile ./filetree.lua)
      (builtins.readFile ./themes/onedark.lua)
      (builtins.readFile ./treesitter.lua)
      telescope
      (builtins.readFile ./trouble.lua)
      (builtins.readFile ./metals.lua)
      (builtins.readFile ./gitsigns.lua)
      (builtins.readFile ./fugitive.lua)
      (builtins.readFile ./notify.lua)
      (builtins.readFile ./autopairs.lua)
      (builtins.readFile ./comments.lua)
      (builtins.readFile ./statusline.lua)
      (builtins.readFile ./bufferline.lua)
      (builtins.readFile ./visuals.lua)
      (builtins.readFile ./json.lua)
      (builtins.readFile ./hop.lua)
      (builtins.readFile ./copilot.lua)
      (builtins.readFile ./undotree.lua)
      (builtins.readFile ./neoclip.lua)
      glowMarkdown
      (builtins.readFile ./actions.lua)
      (builtins.readFile ./surround.lua)
    ]) + ''

      EOF'';
  };

}
