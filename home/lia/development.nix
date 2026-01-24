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

    # Node.js (using fnm for version management)
    nodejs_22
    nodePackages.npm
    nodePackages.pnpm
    nodePackages.yarn
    # For version management, fnm is configured below

    # Python (base is in packages.nix, extras here)
    python3Packages.poetry
    python3Packages.pytest
    python3Packages.mypy
    ruff
    uv

    # C/C++
    gcc
    clang
    clang-tools  # clangd, clang-format
    cmake
    gnumake
    ninja
    gdb
    lldb
    valgrind

    # Build tools
    pkg-config
    autoconf
    automake
    libtool

    # Database tools
    sqlite
    postgresql
    dbeaver-bin  # GUI database client

    # API tools
    httpie
    curlie  # curl with httpie-like output
    insomnia  # REST client GUI

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
  ];

  # Fnm - Fast Node Manager
  programs.fnm = {
    enable = true;
    settings = {
      use-on-cd = true;
      version-file-strategy = "local";
      corepack-enabled = true;
    };
  };

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
