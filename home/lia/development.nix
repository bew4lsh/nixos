{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Rust
    rustup
    # After install: rustup default stable

    # Go
    go
    gopls
    golangci-lint
    delve

    # Zig
    zig
    zls  # Zig language server

    # Node.js (using fnm for version management)
    fnm
    nodejs_22  # Includes npm
    pnpm
    yarn

    # Python (base is in packages.nix, extras here)
    poetry
    python3Packages.pytest
    python3Packages.mypy
    ruff
    uv

    # Python - Data Science
    python3Packages.pandas
    python3Packages.polars
    python3Packages.numpy
    python3Packages.scipy
    python3Packages.matplotlib
    python3Packages.seaborn
    python3Packages.plotly
    python3Packages.jupyterlab
    python3Packages.notebook
    python3Packages.ipywidgets

    # C/C++ (gcc in packages.nix, clang-tools for LSP/formatting)
    clang-tools  # clangd, clang-format (no /bin/c++ conflict)
    ninja
    gdb
    lldb
    valgrind

    # Build tools
    pkg-config
    autoconf
    automake
    libtool

    # Database clients
    sqlite
    postgresql
    mysql84      # MySQL client
    mongosh      # MongoDB shell
    redis        # Redis CLI
    duckdb       # Analytical database
    usql         # Universal database CLI (supports SQL Server, Postgres, MySQL, etc.)
    # clickhouse  # Uncomment if needed - large package

    # Database GUI
    dbeaver-bin

    # Data tools
    visidata     # TUI spreadsheet/data viewer
    csvlens      # CSV viewer TUI
    miller       # CSV/JSON/etc processor

    # API tools
    httpie
    curlie  # curl with httpie-like output
    insomnia  # REST client GUI
    postman   # API testing

    # Formatters & Linters
    treefmt  # Universal formatter
    editorconfig-checker

    # Documentation
    mdbook
    zola

    # Misc dev tools
    just  # Command runner (like make but better)
    watchexec  # File watcher
    hyperfine  # Benchmarking
    tokei  # Code statistics
    entr  # Run commands on file change
    act   # Run GitHub Actions locally
  ];

  # Direnv for per-project environments
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;

    # Standard library extensions
    stdlib = ''
      # Use nix flake
      use_flake() {
        watch_file flake.nix
        watch_file flake.lock
        eval "$(nix print-dev-env --accept-flake-config)"
      }

      # Layout for Python projects
      layout_poetry() {
        if [[ ! -f pyproject.toml ]]; then
          log_error 'No pyproject.toml found. Use `poetry init` to create one.'
          return 1
        fi

        local VENV=$(poetry env info --path 2>/dev/null)
        if [[ -z "$VENV" || ! -d "$VENV" ]]; then
          poetry install
          VENV=$(poetry env info --path)
        fi

        export VIRTUAL_ENV=$VENV
        export POETRY_ACTIVE=1
        PATH_add "$VENV/bin"
      }
    '';
  };

  # Template .envrc files
  home.file = {
    # Nix flake project template
    ".config/direnv/templates/flake.envrc".text = ''
      use flake
    '';

    # Python poetry template
    ".config/direnv/templates/python.envrc".text = ''
      layout poetry
    '';

    # Node template
    ".config/direnv/templates/node.envrc".text = ''
      use fnm
      layout node
    '';
  };
}
