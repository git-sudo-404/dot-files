# Rust development

Rust uses rustaceanvim v8.0.5 (compatible with Neovim 0.11), Mason's
rust-analyzer and CodeLLDB, and the existing AstroNvim DAP UI and mappings.
AstroLSP's normal rust_analyzer handler is disabled to avoid duplicate servers.
Java, Spring Boot and other language settings are unchanged.

The video uses NvChad; this setup keeps AstroNvim. Its existing format-on-save
already calls rust-analyzer/Rustfmt, so rust.vim is unnecessary. Rustup, rust-src,
Rustfmt and Clippy are already installed. crates.nvim provides dependency and
version completion in Cargo.toml only. No automatic dependency upgrades occur.

## Usage

Restart Neovim after installation. Open files inside a Cargo project and allow
initial indexing to finish. The Rust LSP client is now named `rust-analyzer`.

- `gd` or Ctrl-click: go to definition, including standard-library source.
- `<Space>rr`: choose a runnable target.
- `<Space>rt`: choose tests to run.
- `<Space>rd`: choose a target to debug.
- `<Space>ra`: Rust-specific code actions.
- `<Space>db`: toggle breakpoint (existing AstroNvim mapping).
- `<Space>dc`: start/continue debugger (existing mapping).
- `<Space>di`, `<Space>do`, `<Space>dO`: step in, over, out.
- `<Space>du`: toggle debugger UI.
- `<Ctrl-Space>` in Cargo.toml: request completion, including crate versions.

Automatic signature help and Rust-only inlay hints are enabled. Rust snippet
completion uses the existing LuaSnip engine. Formatting requires syntactically
valid Rust; parse errors can prevent Rustfmt from formatting the file.

## Project structure matters

A file is part of a Rust crate only when reachable from its crate root through
module declarations. For example, src/main.rs needs `mod internal;` and
src/internal/mod.rs needs `pub mod node;` to include src/internal/node.rs.
Editor plugins cannot replace these declarations. Project files are not edited
by this configuration.

Plugin versions are pinned for the installed Neovim. Check compatibility before
upgrading rustaceanvim to v9, which requires Neovim 0.12.
