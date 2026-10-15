return {
  "mfussenegger/nvim-jdtls",
  commit = "6e9d953f0b82bccdb834cfde0e893f3119c22592",
  ft = "java",
  dependencies = { "mfussenegger/nvim-dap", "JavaHello/spring-boot.nvim" },
  config = function()
    -- The custom global cmp setup omits snippet expansion; supply it for Java only.
    require("cmp").setup.filetype("java", {
      snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
    })
    local group = vim.api.nvim_create_augroup("user_java", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "java",
      callback = function() require("java.setup").start() end,
    })
    require("java.setup").start()
  end,
}
