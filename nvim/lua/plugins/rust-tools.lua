return {
  {
    "mrcjkb/rustaceanvim",
    -- v9 requires Neovim 0.12; keep the last 0.11-compatible release.
    version = "v8.0.5",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = function()
        local server = require("astrolsp").lsp_opts "rust_analyzer"
        local on_attach = server.on_attach
        server.cmd = { vim.fn.stdpath "data" .. "/mason/bin/rust-analyzer" }
        server.on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          -- The user's global cmp setup omits the snippet expansion callback.
          require("cmp").setup.filetype("rust", {
            snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
          })
          for key, action in pairs {
            ["<leader>rr"] = { "runnables", "Rust: run target" },
            ["<leader>rt"] = { "testables", "Rust: run tests" },
            ["<leader>rd"] = { "debuggables", "Rust: debug target" },
            ["<leader>ra"] = { "codeAction", "Rust: code actions" },
          } do
            vim.keymap.set("n", key, function() vim.cmd.RustLsp(action[1]) end, { buffer = bufnr, desc = action[2] })
          end
        end
        local extension = vim.fn.stdpath "data" .. "/mason/packages/codelldb/extension/"
        -- Reuse AstroNvim's DAP and UI instead of replacing their configuration.
        require "dapui"
        return {
          server = server,
          tools = { test_executor = "background" },
          dap = {
            adapter = require("rustaceanvim.config").get_codelldb_adapter(
              extension .. "adapter/codelldb",
              extension .. "lldb/lib/liblldb.dylib"
            ),
          },
        }
      end
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "codelldb" })
      opts.handlers = opts.handlers or {}
      -- Let rustaceanvim configure it for Rust; do not add C/C++ configurations.
      opts.handlers.codelldb = function() end
    end,
  },
  {
    "saecki/crates.nvim",
    commit = "afcd1cc3eeceb5783676fc8464389b9216a29d05", -- stable
    event = { "BufReadPost Cargo.toml", "BufNewFile Cargo.toml" },
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("crates").setup { completion = { cmp = { enabled = true } } }
      local function completion()
        if vim.fn.expand "%:t" ~= "Cargo.toml" then return end
        local cmp = require "cmp"
        local sources = vim.deepcopy(cmp.get_config().sources)
        if not vim.tbl_contains(vim.tbl_map(function(source) return source.name end, sources), "crates") then
          table.insert(sources, 1, { name = "crates" })
        end
        cmp.setup.buffer { sources = sources }
      end
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        group = vim.api.nvim_create_augroup("user_rust_crates", { clear = true }),
        pattern = "Cargo.toml",
        callback = completion,
      })
      completion()
    end,
  },
}
