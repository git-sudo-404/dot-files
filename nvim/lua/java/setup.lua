local M = {}
local mason = vim.fn.stdpath "data" .. "/mason/packages/"
-- Server JVM only: do not change the shell's JAVA_HOME or project build JVM.
local java_home = vim.env.NVIM_JAVA_HOME or "/opt/homebrew/opt/openjdk@25/libexec/openjdk.jdk/Contents/Home"

function M.root()
  return vim.fs.root(0, { "mvnw", "gradlew", "settings.gradle", "settings.gradle.kts" })
    or vim.fs.root(0, { "pom.xml", "build.gradle", "build.gradle.kts", ".git" })
end

local function java_available()
  if vim.fn.executable(java_home .. "/bin/java") == 1 then return true end
  vim.notify("Java: set NVIM_JAVA_HOME to a JDK 21+ installation", vim.log.levels.ERROR)
  return false
end

function M.start()
  if vim.bo.filetype ~= "java" or not java_available() then return end
  local root = M.root() or vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  if not root then return end
  root = vim.uv.fs_realpath(root) or root
  local workspace = vim.fn.stdpath "cache" .. "/jdtls/" .. vim.fn.sha256(root)
  local bundles =
    vim.fn.glob(mason .. "java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)
  for _, jar in ipairs(vim.fn.glob(mason .. "java-test/extension/server/*.jar", true, true)) do
    local name = vim.fs.basename(jar)
    if name ~= "jacocoagent.jar" and name ~= "com.microsoft.java.test.runner-jar-with-dependencies.jar" then
      bundles[#bundles + 1] = jar
    end
  end
  vim.list_extend(bundles, require("spring_boot").java_extensions())
  local config = require("astrolsp").lsp_opts "jdtls"
  local on_attach = config.on_attach
  config.name = "jdtls"
  config.root_dir = root
  config.cmd = {
    vim.fn.stdpath "data" .. "/mason/bin/jdtls",
    "--java-executable",
    java_home .. "/bin/java",
    "--jvm-arg=-javaagent:" .. mason .. "jdtls/lombok.jar",
    "-configuration",
    workspace .. "/config",
    "-data",
    workspace .. "/data",
  }
  config.init_options = { bundles = bundles }
  local runtimes = {}
  if vim.fn.filereadable(java_home .. "/release") == 1 then
    local release = table.concat(vim.fn.readfile(java_home .. "/release"), "\n")
    local major = release:match 'JAVA_VERSION="(%d+)'
    if major then runtimes[#runtimes + 1] = { name = "JavaSE-" .. major, path = java_home } end
  end
  local jdk17 = "/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home"
  if vim.fn.isdirectory(jdk17) == 1 then runtimes[#runtimes + 1] = { name = "JavaSE-17", path = jdk17 } end
  config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
    java = {
      configuration = { runtimes = runtimes, updateBuildConfiguration = "interactive" },
      maven = { downloadSources = true },
      eclipse = { downloadSources = true },
      signatureHelp = { enabled = true },
    },
  })
  config.on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    require("jdtls").setup_dap { hotcodereplace = "auto" }
    require("jdtls.dap").setup_dap_main_class_configs()
    local function map(key, callback, desc) vim.keymap.set("n", key, callback, { buffer = bufnr, desc = desc }) end
    map("<leader>jo", require("jdtls").organize_imports, "Java: organize imports")
    map("<leader>jt", require("jdtls").test_nearest_method, "Java: test nearest method")
    map("<leader>jT", require("jdtls").test_class, "Java: test class")
  end
  require("jdtls").start_or_attach(config)
end

function M.start_spring()
  if not vim.tbl_contains({ "java", "yaml", "jproperties" }, vim.bo.filetype) then return end
  local root = M.root()
  if not root or not java_available() then return end
  local spring = require "spring_boot"
  local ls_path = spring.get_boot_ls()
  if not ls_path or ls_path == "" then return end
  local launch = require "spring_boot.launch"
  -- Rebuild for every buffer: the older plugin's default autocmd captures one root.
  local server = require("astrolsp").lsp_opts "spring-boot"
  server.root_dir = root
  local config = launch.update_ls_config {
    ls_path = ls_path,
    java_cmd = java_home .. "/bin/java",
    exploded_ls_jar_data = vim.fn.isdirectory(ls_path .. "/BOOT-INF") == 1,
    server = server,
  }
  launch.start(config)
end

return M
