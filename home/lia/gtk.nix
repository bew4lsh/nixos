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
      /* Rosé Pine headerbar styling */
      headerbar {
        background: #1f1d2e;
        color: #e0def4;
        border-bottom: 1px solid #403d52;
      }

      headerbar:backdrop {
        background: #191724;
        color: #6e6a86;
      }

      headerbar .title {
        color: #e0def4;
      }

      headerbar .subtitle {
        color: #908caa;
      }

      /* Window control buttons */
      headerbar button {
        background: #26233a;
        color: #e0def4;
        border: none;
        border-radius: 6px;
      }

      headerbar button:hover {
        background: #403d52;
      }

      headerbar button:active {
        background: #524f67;
      }

      /* Close button accent */
      headerbar button.close:hover {
        background: #eb6f92;
        color: #191724;
      }

      window.background { border-radius: 0; }
    '';

    gtk4.extraCss = ''
      /* Rosé Pine libadwaita color definitions */
      @define-color window_bg_color #191724;
      @define-color window_fg_color #e0def4;
      @define-color view_bg_color #1f1d2e;
      @define-color view_fg_color #e0def4;
      @define-color card_bg_color #1f1d2e;
      @define-color card_fg_color #e0def4;
      @define-color dialog_bg_color #1f1d2e;
      @define-color dialog_fg_color #e0def4;
      @define-color popover_bg_color #26233a;
      @define-color popover_fg_color #e0def4;

      @define-color headerbar_bg_color #191724;
      @define-color headerbar_fg_color #e0def4;
      @define-color headerbar_backdrop_color #191724;
      @define-color headerbar_border_color #403d52;
      @define-color headerbar_shade_color rgba(0, 0, 0, 0.36);

      @define-color sidebar_bg_color #191724;
      @define-color sidebar_fg_color #e0def4;
      @define-color sidebar_backdrop_color #191724;
      @define-color sidebar_shade_color rgba(0, 0, 0, 0.25);
      @define-color secondary_sidebar_bg_color #1f1d2e;
      @define-color secondary_sidebar_fg_color #e0def4;
      @define-color secondary_sidebar_backdrop_color #1f1d2e;
      @define-color secondary_sidebar_shade_color rgba(0, 0, 0, 0.25);

      @define-color accent_color #c4a7e7;
      @define-color accent_bg_color #31748f;
      @define-color accent_fg_color #e0def4;

      @define-color destructive_bg_color #eb6f92;
      @define-color destructive_fg_color #191724;
      @define-color destructive_color #eb6f92;
      @define-color success_bg_color #9ccfd8;
      @define-color success_fg_color #191724;
      @define-color success_color #9ccfd8;
      @define-color warning_bg_color #f6c177;
      @define-color warning_fg_color #191724;
      @define-color warning_color #f6c177;
      @define-color error_bg_color #eb6f92;
      @define-color error_fg_color #191724;
      @define-color error_color #eb6f92;

      @define-color borders #403d52;
      @define-color shade_color rgba(0, 0, 0, 0.25);
      @define-color scrollbar_outline_color rgba(0, 0, 0, 0.5);
      @define-color thumbnail_bg_color #1f1d2e;
      @define-color thumbnail_fg_color #e0def4;

      /* Fallback overrides */
      window, window.background, .background {
        background-color: #191724;
        color: #e0def4;
      }

      headerbar, .titlebar {
        background-color: #191724;
        background-image: none;
        color: #e0def4;
        border-bottom: 1px solid #403d52;
        box-shadow: none;
      }

      .navigation-sidebar, .sidebar {
        background-color: #191724;
      }

      .view, .content, .main-content, .content-area {
        background-color: #1f1d2e;
      }

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
