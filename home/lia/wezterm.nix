{ config, pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()

      -- Rosé Pine colors
      config.colors = {
        foreground = '#e0def4',
        background = '#191724',
        cursor_bg = '#524f67',
        cursor_fg = '#e0def4',
        cursor_border = '#524f67',
        selection_fg = '#e0def4',
        selection_bg = '#403d52',
        scrollbar_thumb = '#26233a',
        split = '#403d52',
        ansi = {
          '#26233a',  -- black
          '#eb6f92',  -- red
          '#31748f',  -- green
          '#f6c177',  -- yellow
          '#9ccfd8',  -- blue
          '#c4a7e7',  -- magenta
          '#ebbcba',  -- cyan
          '#e0def4',  -- white
        },
        brights = {
          '#6e6a86',  -- bright black
          '#eb6f92',  -- bright red
          '#31748f',  -- bright green
          '#f6c177',  -- bright yellow
          '#9ccfd8',  -- bright blue
          '#c4a7e7',  -- bright magenta
          '#ebbcba',  -- bright cyan
          '#e0def4',  -- bright white
        },
        tab_bar = {
          background = '#191724',
          active_tab = {
            bg_color = '#26233a',
            fg_color = '#e0def4',
            intensity = 'Normal',
            underline = 'None',
            italic = false,
            strikethrough = false,
          },
          inactive_tab = {
            bg_color = '#191724',
            fg_color = '#6e6a86',
          },
          inactive_tab_hover = {
            bg_color = '#1f1d2e',
            fg_color = '#908caa',
            italic = false,
          },
          new_tab = {
            bg_color = '#191724',
            fg_color = '#6e6a86',
          },
          new_tab_hover = {
            bg_color = '#1f1d2e',
            fg_color = '#e0def4',
          },
        },
      }

      -- Font configuration
      config.font = wezterm.font_with_fallback {
        { family = 'JetBrainsMono Nerd Font', weight = 'Medium' },
        'Noto Color Emoji',
      }
      config.font_size = 12.0
      config.line_height = 1.1

      -- Window configuration
      config.window_background_opacity = 0.95
      config.window_decorations = 'RESIZE'
      config.window_padding = {
        left = 12,
        right = 12,
        top = 12,
        bottom = 12,
      }

      -- Tab bar
      config.enable_tab_bar = true
      config.use_fancy_tab_bar = false
      config.tab_bar_at_bottom = true
      config.hide_tab_bar_if_only_one_tab = true

      -- Scrollback
      config.scrollback_lines = 10000

      -- Cursor
      config.default_cursor_style = 'SteadyBar'
      config.cursor_blink_rate = 500

      -- Bell
      config.audible_bell = 'Disabled'
      config.visual_bell = {
        fade_in_duration_ms = 75,
        fade_out_duration_ms = 75,
        target = 'CursorColor',
      }

      -- Wayland
      config.enable_wayland = true

      -- Key bindings
      config.keys = {
        -- Split panes (like zellij/tmux)
        { key = '|', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
        { key = '_', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },

        -- Navigate panes
        { key = 'h', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Left' },
        { key = 'l', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Right' },
        { key = 'k', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Up' },
        { key = 'j', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Down' },

        -- New tab
        { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },

        -- Close pane
        { key = 'w', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentPane { confirm = true } },
      }

      return config
    '';
  };
}
