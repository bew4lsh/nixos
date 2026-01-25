{ config, pkgs, ... }:

{
  # GTK theming
  gtk = {
    enable = true;

    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };

    iconTheme = {
      name = "rose-pine-icons";
      package = pkgs.rose-pine-icon-theme;
    };

    font = {
      name = "Inter";
      size = 11;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "appmenu:none";
      gtk-enable-animations = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "appmenu:none";
      gtk-enable-animations = true;
    };

    gtk3.extraCss = ''
      /* Remove rounded corners from windows */
      window.background { border-radius: 0; }
    '';

    gtk4.extraCss = ''
      /* Remove rounded corners from windows */
      window.background { border-radius: 0; }
    '';
  };

  # Qt theming (use Kvantum for Rosé Pine consistency)
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  # DConf settings for GNOME apps
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-animations = true;
      font-antialiasing = "rgba";
      font-hinting = "slight";
      gtk-theme = "rose-pine";
      icon-theme = "rose-pine-icons";
      cursor-theme = "BreezeX-RosePine-Linux";
      font-name = "Inter 11";
      document-font-name = "Inter 11";
      monospace-font-name = "JetBrainsMono Nerd Font 10";
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "";  # No window buttons, niri handles this
    };

    # File chooser settings
    "org/gtk/gtk4/settings/file-chooser" = {
      sort-directories-first = true;
      show-hidden = false;
    };

    "org/gtk/settings/file-chooser" = {
      sort-directories-first = true;
      show-hidden = false;
    };

    # Nautilus settings
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      show-hidden-files = false;
    };

    "org/gnome/nautilus/list-view" = {
      default-zoom-level = "small";
      use-tree-view = true;
    };
  };

  # Additional theming packages
  home.packages = with pkgs; [
    # Themes
    rose-pine-gtk-theme
    rose-pine-icon-theme

    # Fonts
    inter
    nerd-fonts.jetbrains-mono

    # Cursor themes
    rose-pine-cursor

  ];
}
