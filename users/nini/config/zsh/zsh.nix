{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "vi-mode"
      ];
      theme = "agnoster";
    };

    # Use for API keys
    initContent = ''
      if [ -f "$HOME/.secrets/env.sh" ]; then
        source "$HOME/.secrets/env.sh"
      fi
    '';

    plugins = [
      { 
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "caa749d030d22168445c4cb97befd406d2828db0";
          sha256 = "YV9lpJ0X2vN9uIdroDWEize+cp9HoKegS3sZiSpNk50=";
        };
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner= "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
          sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
    ];
    localVariables = {
      EDITOR = "vim";
    };
  
    shellAliases = {
      # run aider with llama model - the most reliable way to force the flags
      aider-llama-architect = "aider --model openai/Meta-Llama-3.1-405B-Instruct --alias openai/Meta-Llama-3.1-405B-Instruct:gpt-4o";
      aider-llama-code = "aider --model openai/Meta-Llama-3.1-405B-Instruct --alias openai/Meta-Llama-3.1-405B-Instruct:gpt-4o --auto-accept-architect";

      # cabal
      cb = "cabal build";
      crwd = "cabal repl --with-compiler=doctest";
      ct = "cabal test";

      # spago
      sb = "spago build";
      st = "spago test";
      stp = "spago test --main Test.Plutip";

      # rust
      crb = "cargo build";
      crt = "cargo test";
      crn = "cargo new";

      # make
      mrb = "make run-build";
      mrd = "make run-dev-dashboard";
      mf = "make format";

      # nix
      # Load the zsh shell with flakes
      nd = "nix develop -c zsh";
      # Need nightly for miri
      ndm = "nix develop .#nightly -c zsh";

      # nvim
      nv = "nvim";

      # git
      gs = "git status";
      ga = "git add";

      # ls
      ls = "eza";
    };
  };
}
