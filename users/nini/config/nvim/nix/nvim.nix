# Neovim settings

{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    # Sets alias vim=nvim
    vimAlias = true;

    extraConfig = builtins.readFile(../vim/general-vim-settings.vim);

    # Neovim plugins
    plugins = with pkgs.vimPlugins; [

      {
        plugin = nerdtree;
        config = builtins.readFile(../vim/nerdtree-settings.vim);
      }

      {
        plugin = fzf-vim;
        config = builtins.readFile(../vim/fzf-settings.vim);
      }

      auto-pairs
      purescript-vim
      haskell-vim
      vim-commentary
      YouCompleteMe
      vim-nix
      vim-markdown
      nvim-lspconfig
    ];
  };
}
