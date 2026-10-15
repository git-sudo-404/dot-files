# Java and Spring Boot

Java uses nvim-jdtls and the Mason-installed JDTLS, debugger and test bundles.
Spring uses spring-boot.nvim pinned before its Neovim 0.12 migration, so this
configuration continues to support the installed Neovim 0.11 / AstroNvim v4.
Do not remove the pins without checking compatibility.

The language servers use the existing Homebrew JDK 25. This does not change
JAVA_HOME for your shell, Maven or Gradle. Project Java versions still belong
in pom.xml / build.gradle and your build tool's toolchain configuration.
Java 17 is also registered with JDTLS using the installed Temurin path.

Open the project from its Maven/Gradle root. JDTLS stores a separate cache
for each absolute project root. The first import can take time.

- `:LspInfo`: expect one jdtls client for the project and a spring-boot client.
- `<Space>jo`: organize Java imports.
- `<Space>jt`: run/debug the nearest Java test.
- `<Space>jT`: run/debug the Java test class.
- Existing AstroNvim debugger mappings remain available.
- `:JdtUpdateConfig`: refresh after changing build dependencies.
- Spring property completion applies to application*.yml / application*.properties.
- Telescope workspace symbols can query Spring symbols with `@`, `@+`, `@/`.

Required Mason packages (already installed at setup time): jdtls,
java-debug-adapter, java-test, vscode-spring-boot-tools.

Configuration lives in lua/java/setup.lua and the Java/Spring plugin specs.
If you relocate Java, update the server JDK path and its runtime name together.
