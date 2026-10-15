return {
  "JavaHello/spring-boot.nvim",
  -- Last revision before the Neovim 0.12 migration; this config uses 0.11.
  commit = "eea95b752bceb6ca410b3e2d87a1a02d08bd61a6",
  ft = { "java", "yaml", "jproperties" },
  config = function()
    require("spring_boot").setup { autocmd = false }
    local group = vim.api.nvim_create_augroup("user_spring_boot", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = { "java", "yaml", "jproperties" },
      callback = function() require("java.setup").start_spring() end,
    })
    require("java.setup").start_spring()
  end,
}
