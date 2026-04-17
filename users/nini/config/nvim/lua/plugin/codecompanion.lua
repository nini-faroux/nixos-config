require("codecompanion").setup({
  adapters = {
    -- Override the built-in 'openai' adapter to point to proxy
    openai = function()
      return require("codecompanion.adapters").extend("openai", {
        url = "http://127.0.0.1:8080/v1/gemini/completions",
        env = { api_key = "dummy" },
        -- model = "gemini-2.0-flash",
        model= "gemini-1.5-flash",
      })
    end,

    -- Keep anthropic as is
    anthropic = function()
      return require("codecompanion.adapters").extend("anthropic", {
        url = "http://localhost:8080/v1/messages",
        env = { api_key = "dummy" },
      })
    end,
  },
  strategies = {
    chat = {
      adapter = "openai", -- Point to the overridden 'openai' adapter
    },
    inline = {
      adapter = "openai",
    },
  },
  opts = {
    log_level = "DEBUG",
  },
})
