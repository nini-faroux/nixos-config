{ pkgs, ... }:
{
  programs.neovim =
    let
       toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in 
    {
      enable = true;
  
      viAlias = true;
      vimAlias = true; vimdiffAlias = true; extraLuaConfig = ''
        ${builtins.readFile ./lua/options.lua}
      '';
 
      extraPackages = with pkgs; [
    	# Lua lsp
    	luajitPackages.lua-lsp
        lua-language-server
    	# TypeScript lsp
    	nodePackages.typescript
    	nodePackages.typescript-language-server
    	# Python lsp
    	pyright
    	ruff
      ];

      plugins = with pkgs.vimPlugins; [
        {
          plugin = nvim-lspconfig;
          config = toLuaFile ./lua/plugin/lsp.lua;
        }
  
    	tokyonight-nvim
  
    	# Tree-sitter parsers for syntax highlighting etc.
    	{
    	  plugin = nvim-treesitter;
    	  config = toLuaFile ./lua/plugin/treesitter.lua;
    	}

        nvim-treesitter-parsers.haskell
    	nvim-treesitter-parsers.python

        cmp_luasnip
        luasnip

        cmp-nvim-lsp
        neodev-nvim

        nvim-cmp 
        {
          plugin = nvim-cmp;
          config = toLuaFile ./lua/plugin/cmp.lua;
        }
  
        {
          plugin = telescope-nvim;
          config = toLuaFile ./lua/plugin/telescope.lua;
        }
  
    	{
    	  plugin = pkgs.vimPlugins.own-oil;
    	  config = toLuaFile ./lua/plugin/oil.lua;
    	}
  
    	own-purescript-vim
     ];
  
    };
}
