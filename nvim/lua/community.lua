-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  -- import/override with your plugins folder
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.utility.hover-nvim" },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup {
        variant = "moon",
        -- disable_background = true,

        highlight_groups = {
          Normal = { bg = "NONE" },
          NormalNC = { bg = "NONE" },
          CursorLine = { bg = "NONE" },
          BufferLineFill = { bg = "NONE" },
          BufferLineBuffer = { bg = "NONE" },
          BufferLineBufferVisible = { bg = "NONE" },
          BufferLineBufferSelected = { bg = "NONE" },
          StatusLine = { bg = "NONE" },
          StatusLineNC = { bg = "NONE" },
          WinBar = { bg = "NONE" },
          WinBarNC = { bg = "NONE" },
          TabLine = { bg = "NONE" },
          TabLineSel = { bg = "NONE" },
          TabLineFill = { bg = "NONE" },
          NormalFloat = { bg = "NONE" },
          FloatBorder = { bg = "NONE" },
          TelescopeNormal = { bg = "NONE" },
          TelescopeBorder = { bg = "NONE" },
          TelescopePromptNormal = { bg = "NONE" },
          TelescopeResultsNormal = { bg = "NONE" },
          ToggleTermFloat = { bg = "NONE" },
        },
      }
      vim.cmd "colorscheme rose-pine"
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = true,
    priority = 1000,
    config = function() require("github-theme").setup {} end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  { "echasnovski/mini.nvim", version = "*" },
}
