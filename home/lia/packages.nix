{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Development - Python
    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.ipython

    # Development - C/C++ (for neovim treesitter)
    gcc
    gnumake
    cmake

    # Development - General
    git
    gh  # GitHub CLI
    lazygit
    delta  # Better git diff

    # AI Tools
    claude-code  # Anthropic's CLI coding assistant

    # JetBrains (DataGrip)
    jetbrains.datagrip

    # CLI tools
    ripgrep
    fd
    sd  # sed alternative
    jq
    yq-go
    tokei  # Code statistics
    hyperfine  # Benchmarking
    trash-cli
    duf  # Disk usage
    ncdu  # NCurses disk usage
    procs  # Process viewer
    bottom  # System monitor
    bandwhich  # Network monitor

    # Archive tools
    unzip
    p7zip
    unrar

    # Media
    mpv
    yt-dlp

    # Image tools
    imagemagick
    ffmpeg

    # Networking
    wget
    curl
    rsync
    aria2

    # System info
    neofetch
    fastfetch
    cpufetch

    # Nix tools
    nix-tree
    nix-diff
    comma  # Run programs without installing

    # Desktop shell
    quickshell  # For IPC commands with Noctalia

    # Misc
    pciutils
    usbutils
    lshw
    dmidecode
  ];
}
