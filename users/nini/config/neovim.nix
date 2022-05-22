# Neovim settings

{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    # Sets alias vim=nvim
    vimAlias = true;

    extraConfig = ''
      :imap jj <Esc>
      :set number
    '';

    # Neovim plugins
    plugins = with pkgs.vimPlugins; [
      nerdtree
      vim-nix
      vim-markdown
    ];
  };
}
