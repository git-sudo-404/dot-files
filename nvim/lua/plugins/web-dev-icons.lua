-- File: lua/plugins/icons.lua

return {
  "nvim-tree/nvim-web-devicons",
  config = function()
    local devicons = require "nvim-web-devicons"

    -- This is the setup part
    devicons.setup {
      -- You can override any icon or color here
      override_by_filename = {
        ["docker-compose.yml"] = {
          icon = "", -- The docker whale icon
          color = "#e03c3c", -- A red color
          name = "DockerComposeYml", -- A unique name for the highlight group
        },
        ["docker-compose.yaml"] = {
          icon = "",
          color = "#e03c3c",
          name = "DockerComposeYaml",
        },
      },
      -- You can also override by file extension
      override_by_extension = {
        ["log"] = {
          icon = "",
          color = "#c792ea",
          name = "LogFile",
        },
      },
    }
  end,
}
