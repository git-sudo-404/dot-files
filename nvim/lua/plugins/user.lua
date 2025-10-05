---@type LazySpec
return {
  -- == Examples of Adding Plugins ==
  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==
  -- customize alpha options
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        " █████  ███████ ████████ ██████   ██████",
        "██   ██ ██         ██    ██   ██ ██    ██",
        "███████ ███████    ██    ██████  ██    ██",
        "██   ██      ██    ██    ██   ██ ██    ██",
        "██   ██ ███████    ██    ██   ██  ██████",
        " ",
        "    ███    ██ ██    ██ ██ ███    ███",
        "    ████   ██ ██    ██ ██ ████  ████",
        "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
        "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
        "    ██   ████   ████   ██ ██      ██",
      }
      return opts
    end,
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = true },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules {
        Rule("$", "$", { "tex", "latex" })
          -- don't add a pair if the next character is %
          :with_pair(cond.not_after_regex "%%")
          -- don't add a pair if the previous character is xxx
          :with_pair(cond.not_before_regex("xxx", 3))
          -- don't move right when repeating character
          :with_move(cond.none())
          -- don't delete if the next character is xx
          :with_del(cond.not_after_regex "xx")
          -- disable adding a newline when pressing <cr>
          :with_cr(cond.none()),
      }
    end,
  },

  {
    {
      "AstroNvim/astroui",
      ---@type AstroUIOpts
      opts = {
        icons = {
          -- Programming Languages
          Javascript = "", -- JavaScript file
          JavascriptReact = "", -- React (JS) file
          Typescript = "", -- TypeScript file
          TypescriptReact = "", -- React (TS) file
          Python = "", -- Python file
          Cpp = "", -- C++ file
          C = "", -- C file
          Java = "", -- Java file
          Html = "", -- HTML file
          Css = "", -- CSS file
          Json = "", -- JSON file
          Markdown = "", -- Markdown file
          Go = "", -- Go file
          Ruby = "", -- Ruby file
          Rust = "", -- Rust file
          Php = "", -- PHP file
          Lua = "", -- Lua file
          Shell = "", -- Shell script file
          Dockerfile = "", -- Dockerfile
          Yaml = "", -- YAML file
          Swift = "", -- Swift file

          -- UI / LSP / Debugging Icons
          ActiveLSP = "",
          ActiveTS = "",
          BufferClose = "",
          DapBreakpoint = "",
          DapBreakpointCondition = "",
          DapBreakpointRejected = "",
          DapLogPoint = "",
          DapStopped = "",
          DefaultFile = "",
          Diagnostic = "",
          DiagnosticError = "",
          DiagnosticHint = "",
          DiagnosticInfo = "",
          DiagnosticWarn = "",
          Ellipsis = "",
          FileModified = "",
          FileReadOnly = "",
          FoldClosed = "",
          FoldOpened = "",
          FolderClosed = "",
          FolderEmpty = "",
          FolderOpen = "",
          Git = "",
          GitAdd = "",
          GitBranch = "",
          GitChange = "",
          GitConflict = "",
          GitDelete = "",
          GitIgnored = "",
          GitRenamed = "",
          GitStaged = "",
          GitUnstaged = "",
          GitUntracked = "",
          LSPLoaded = "",
          LSPLoading1 = "",
          LSPLoading2 = "",
          LSPLoading3 = "",
          MacroRecording = "",
          Paste = "",
          Search = "",
          Selected = "",
          TabClose = "",
        },
      },
    },
    {
      "onsails/lspkind.nvim",
      opts = function(_, opts)
        -- Use codicons preset
        opts.preset = "codicons"
        opts.mode = "symbol_text"
        -- Set some missing symbol types
        opts.symbol_map = {
          Array = "",
          Boolean = "",
          Key = "",
          Namespace = "",
          Null = "",
          Number = "",
          Object = "",
          Package = "",
          String = "",
        }
      end,
    },
  },
}
