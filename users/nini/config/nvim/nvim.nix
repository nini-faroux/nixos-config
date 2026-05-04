{ pkgs, ... }:
{

  programs.neovim =
    let
       toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in 
    {
      enable = true;

      # Fix warnings in new version
      withRuby = false;
      withPython3 = false;

      viAlias = true;
      vimAlias = true; vimdiffAlias = true; initLua = ''
        ${builtins.readFile ./lua/options.lua}
      '';
 
      extraPackages = with pkgs; [
    	# Lua lsp
    	luajitPackages.lua-lsp
        lua-language-server

    	# TypeScript lsp

    	# Python lsp
    	pyright
    	ruff
      ];

      plugins = with pkgs.vimPlugins; [
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = builtins.readFile ./lua/plugin/lsp.lua;
        }
  
    	tokyonight-nvim
  
    	# Tree-sitter parsers for syntax highlighting etc.
    	{
    	  plugin = nvim-treesitter;
          type = "lua";
    	  config = builtins.readFile ./lua/plugin/treesitter.lua;
    	}

        nvim-treesitter-parsers.haskell
        nvim-treesitter-parsers.purescript
    	nvim-treesitter-parsers.python

        cmp_luasnip
        luasnip

        cmp-nvim-lsp
        neodev-nvim

        nvim-cmp 
        {
          plugin = nvim-cmp;
          type = "lua";
          config = builtins.readFile ./lua/plugin/cmp.lua;
        }
  
        {
          plugin = telescope-nvim;
          type = "lua";
          config = builtins.readFile ./lua/plugin/telescope.lua;
        }

        {
          plugin = codecompanion-nvim;
          type = "lua";
          config = builtins.readFile ./lua/plugin/codecompanion.lua;
        }
  
    	{
    	  plugin = pkgs.vimPlugins.own-oil;
          type = "lua";
    	  config = builtins.readFile ./lua/plugin/oil.lua;
    	}
  
     ];
  
    };
}
