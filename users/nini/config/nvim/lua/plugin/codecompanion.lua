-- Patch the real anthropic adapter BEFORE CodeCompanion uses it
local anthropic = require("codecompanion.adapters.http.anthropic")

anthropic.url = "http://localhost:8080/v1/messages"
anthropic.api_key = "dummy"

require("codecompanion").setup({
  adapter = "anthropic",

  interactions = {
    chat = {
      adapter = "anthropic",
      model = "claude-sonnet-4-20250514",
    },
    inline = {
      adapter = "anthropic",
    },
  },

  opts = {
    log_level = "DEBUG",
  },
})

-- require("codecompanion").setup({
--   interactions = {
--     chat = {
--       adapter = "anthropic_proxy",
--       model = "claude-sonnet-4-20250514",
--     },
--     inline = {
--       adapter = "anthropic_proxy",
--     },
--   },
-- 
--   adapters = {
--     anthropic_proxy = function()
--       return require("codecompanion.adapters").extend("anthropic", {
--         url = "http://localhost:8080/v1/messages",
--         api_key = "dummy",
--       })
--     end,
-- 
--     openai_proxy = function()
--       return require("codecompanion.adapters").extend("openai", {
--         url = "http://localhost:8080/v1/responses",
--         api_key = "dummy",
--       })
--     end,
--   },
-- 
--   opts = {
--     log_level = "DEBUG",
--   },
-- })
