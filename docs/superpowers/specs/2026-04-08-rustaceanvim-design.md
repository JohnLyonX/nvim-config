# Rustaceanvim Design

**Goal:** Replace the generic `rust_analyzer` setup with `rustaceanvim` while keeping the existing `nvim-lspconfig` setup for all non-Rust languages.

## Scope

This change only affects Rust support.

- `nvim-lspconfig` remains installed and continues to manage non-Rust language servers.
- The generic `rust_analyzer` entry is removed from the shared server lists.
- A dedicated `rustaceanvim` plugin file is added to own Rust LSP behavior.

## Architecture

Rust support will move from the shared LSP module into a dedicated plugin module under `lua/johnlyon/plugins/`. That module will lazily load for Rust files and configure `rustaceanvim` with the same `cmp-nvim-lsp` capabilities already used elsewhere in the config.

Shared LSP keymaps will remain defined in the existing `nvim-lspconfig` module for now. The Rust module will define a matching `LspAttach`-style keymap set for Rust buffers so behavior stays consistent after `rust_analyzer` is removed from the generic loop.

## Components

### Shared LSP Config

`lua/johnlyon/plugins/lsp/lspconfig.lua` will:

- stop listing `rust_analyzer` in the generic server list
- keep the shared diagnostic signs
- continue enabling the remaining language servers

### Mason Config

`lua/johnlyon/plugins/lsp/mason.lua` will:

- stop asking `mason-lspconfig` to manage `rust_analyzer`
- keep `rust-analyzer` in the tool installer list so the binary is still installed

### Rust Plugin Config

`lua/johnlyon/plugins/rustaceanvim.lua` will:

- add `mrcjkb/rustaceanvim`
- load only for Rust buffers
- configure `server.capabilities` using `cmp-nvim-lsp`
- apply Rust buffer keymaps aligned with the existing LSP UX

## Error Handling

- If `rust-analyzer` is not installed, `rustaceanvim` will not provide Rust LSP features until Mason installs it.
- Non-Rust languages remain on the current path, so any Rust-specific issue stays isolated from the rest of the editor config.

## Testing

Verification should prove three things:

1. Neovim loads without config errors in headless mode.
2. `rust_analyzer` no longer appears in the shared `nvim-lspconfig` server list.
3. `rustaceanvim` loads for Rust and exposes the configured server settings.
