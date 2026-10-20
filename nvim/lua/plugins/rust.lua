-- Rust-only navigation; other languages keep their existing mappings.
return {
  {
    "AstroNvim/astrolsp",
    opts = {
      handlers = { rust_analyzer = false }, -- rustaceanvim owns Rust startup.
      mappings = {
        n = {
          ["<C-LeftMouse>"] = {
            function()
              -- Do not replay LeftMouse: the held Ctrl modifier can invoke tag lookup.
              local mouse = vim.fn.getmousepos()
              if mouse.winid == 0 or mouse.line == 0 or mouse.column == 0 then return end
              if vim.bo[vim.api.nvim_win_get_buf(mouse.winid)].filetype ~= "rust" then return end
              vim.api.nvim_set_current_win(mouse.winid)
              local line = vim.api.nvim_buf_get_lines(0, mouse.line - 1, mouse.line, false)[1] or ""
              vim.api.nvim_win_set_cursor(mouse.winid, { mouse.line, math.min(mouse.column - 1, #line) })
              vim.lsp.buf.definition()
            end,
            desc = "Rust: go to definition at mouse",
            cond = function(client) return client.name == "rust_analyzer" or client.name == "rust-analyzer" end,
          },
        },
      },
    },
  },
}
