# Neovim settings

{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    # Sets alias vim=nvim
    vimAlias = true;

    extraConfig = builtins.readFile(./general-vim-settings.vim);

    # Neovim plugins
    plugins = with pkgs.vimPlugins; [

      {
        plugin = nerdtree;
        config = builtins.readFile(./nerdtree-settings.vim);
      }


      {
        plugin = fzf-vim;
        config = builtins.readFile(./fzf-settings.vim);
      }

      auto-pairs
      purescript-vim
      haskell-vim
      vim-commentary
      YouCompleteMe
      vim-nix
      vim-markdown
    ];
  };
}
