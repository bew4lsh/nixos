{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    # Firefox policies (system-wide settings)
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxAccounts = false;
      DisableAccounts = false;
      DisableFirefoxScreenshots = false;
      DisplayBookmarksToolbar = "newtab";
      DontCheckDefaultBrowser = true;
      SearchBar = "unified";

      # Extensions to install
      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Bitwarden (optional, uncomment if you use it)
        # "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        #   installation_mode = "force_installed";
        # };
      };

      Preferences = {
        # Privacy
        "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
        "privacy.donottrackheader.enabled" = { Value = true; Status = "locked"; };
        "privacy.trackingprotection.enabled" = { Value = true; Status = "locked"; };
        "privacy.trackingprotection.socialtracking.enabled" = { Value = true; Status = "locked"; };

        # Performance
        "gfx.webrender.all" = { Value = true; Status = "default"; };
        "media.ffmpeg.vaapi.enabled" = { Value = true; Status = "default"; };
        "media.hardware-video-decoding.enabled" = { Value = true; Status = "default"; };

        # Wayland
        "widget.use-xdg-desktop-portal.file-picker" = { Value = 1; Status = "default"; };

        # UI
        "browser.uidensity" = { Value = 1; Status = "default"; };
        "browser.tabs.inTitlebar" = { Value = 0; Status = "default"; };
      };
    };

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      # User preferences
      settings = {
        # General
        "browser.startup.homepage" = "about:home";
        "browser.newtabpage.enabled" = true;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;

        # Search
        "browser.search.defaultenginename" = "DuckDuckGo";
        "browser.search.order.1" = "DuckDuckGo";

        # Downloads
        "browser.download.dir" = "${config.home.homeDirectory}/Downloads";
        "browser.download.useDownloadDir" = true;

        # Appearance
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.theme.dark-private-windows" = true;

        # Scrolling
        "general.smoothScroll" = true;
        "mousewheel.default.delta_multiplier_y" = 200;

        # Privacy extras
        "dom.security.https_only_mode" = true;
        "browser.xul.error_pages.expert_bad_cert" = true;

        # Disable annoying features
        "extensions.pocket.enabled" = false;
        "browser.tabs.firefox-view" = false;
      };

      # Custom CSS for Rosé Pine theming (optional)
      userChrome = ''
        /* Rosé Pine Firefox Theme */
        :root {
          --rose-pine-base: #191724;
          --rose-pine-surface: #1f1d2e;
          --rose-pine-overlay: #26233a;
          --rose-pine-muted: #6e6a86;
          --rose-pine-subtle: #908caa;
          --rose-pine-text: #e0def4;
          --rose-pine-love: #eb6f92;
          --rose-pine-gold: #f6c177;
          --rose-pine-rose: #ebbcba;
          --rose-pine-pine: #31748f;
          --rose-pine-foam: #9ccfd8;
          --rose-pine-iris: #c4a7e7;
        }

        /* Tab bar background */
        #TabsToolbar {
          background-color: var(--rose-pine-base) !important;
        }

        /* Navigation bar */
        #nav-bar {
          background-color: var(--rose-pine-surface) !important;
        }

        /* URL bar */
        #urlbar-background {
          background-color: var(--rose-pine-overlay) !important;
        }
      '';

      userContent = ''
        /* Style about: pages */
        @-moz-document url-prefix("about:") {
          :root {
            --in-content-page-background: #191724 !important;
            --in-content-page-color: #e0def4 !important;
          }
        }
      '';
    };
  };
}
