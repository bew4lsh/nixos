{ config, pkgs, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Dependencies for LSP, treesitter, formatters, etc.
    extraPackages = with pkgs; [
      # Language servers
      lua-language-server
      nil  # Nix LSP
      pyright
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      marksman  # Markdown LSP

      # Formatters
      stylua
      nixpkgs-fmt
      black
      nodePackages.prettier
      shfmt

      # Treesitter compilers
      gcc
      gnumake
      nodejs_22  # Match version in development.nix

      # Tools your config might need
      ripgrep
      fd
      git
    ];
  };

  # Symlink your nvim config from the flake input
  xdg.configFile."nvim" = {
    source = inputs.nvim-config;
    recursive = true;
  };
}
