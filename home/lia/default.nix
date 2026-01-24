{ config, pkgs, inputs, ... }:

{
  imports = [
    ./niri.nix
    ./waybar.nix
    ./fuzzel.nix
    ./mako.nix
    ./wezterm.nix
    ./neovim.nix
    ./firefox.nix
    ./shell.nix
    ./gtk.nix
    ./packages.nix
  ];

  home = {
    username = "lia";
    homeDirectory = "/home/lia";
    stateVersion = "24.11";
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # User directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  # Cursor theme
  home.pointerCursor = {
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Session variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
    TERMINAL = "wezterm";
  };

  # Systemd user services
  systemd.user.startServices = "sd-switch";
}
