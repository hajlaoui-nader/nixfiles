{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ telescope-nvim ];
    # extraConfig = ''
    #   lua << EOF
    #     ${builtins.readFile ./config.lua}
    #   EOF
    # '';

    extraConfig = ''
      syntax on
      let mapleader=" "
      let maplocalleader=" "
      set nowrap                            " disable line wrap
      set relativenumber                    " show relative line number
      set encoding=utf-8
      set mouse=v                           " deactive mouse
      set tabstop=2
      set shiftwidth=2
      set softtabstop=2
      set expandtab
      set cmdheight=1
      set updatetime=300
      set shortmess+=c
      set tm=500
      set hidden
      set splitbelow
      set splitright
      set signcolumn=yes
      set autoindent
      set noswapfile
      set nobackup
      set nowritebackup
      set nohlsearch
      set incsearch
      set termguicolors
      set t_Co=256
      
    '';

  };

}
