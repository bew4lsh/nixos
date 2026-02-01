{ config, pkgs, ... }:

{
  # Bash configuration
  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyControl = [ "erasedups" "ignorespace" ];
    historyFileSize = 100000;
    historySize = 100000;

    shellAliases = {
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # ls replacements (using eza if available)
      ls = "eza --icons";
      ll = "eza -la --icons";
      la = "eza -a --icons";
      lt = "eza --tree --icons";
      l = "eza -l --icons";

      # Safety
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";

      # Git
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline";
      gd = "git diff";

      # NixOS
      rebuild = "sudo nixos-rebuild switch --flake /home/lia/nixos#$(hostname)";
      update = "nix flake update /home/lia/nixos";
      garbage = "sudo nix-collect-garbage -d";
      generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";

      # Editors
      v = "nvim";
      vim = "nvim";

      # Claude
      badclaude = "claude --dangerously-skip-permissions";

      # Tools
      cat = "bat";
      find = "fd";
      grep = "rg";
      lg = "lazygit";

      # WezTerm
      tabname = "wezterm cli set-tab-title";
      tn = "wezterm cli set-tab-title";

      # Quick commands
      c = "clear";
      cls = "clear";
      h = "history";
      y = "yazi";
      q = "exit";
      ports = "ss -tulanp";
      meminfo = "free -h";
      cpuinfo = "lscpu";
      df = "df -h";
      du = "du -h";
      mkdir = "mkdir -pv";

      # Quick access
      nixconf = "cd /home/lia/nixos && nvim";
    };

    bashrcExtra = ''
      # Enable vi mode (optional, uncomment if you want)
      # set -o vi

      # Better history search with up/down arrows (only in interactive shells)
      if [[ $- == *i* ]]; then
        bind '"\e[A": history-search-backward'
        bind '"\e[B": history-search-forward'
        bind 'set completion-ignore-case on'
        bind 'set show-all-if-ambiguous on'
      fi

      # Color man pages
      export LESS_TERMCAP_mb=$'\e[1;32m'
      export LESS_TERMCAP_md=$'\e[1;32m'
      export LESS_TERMCAP_me=$'\e[0m'
      export LESS_TERMCAP_se=$'\e[0m'
      export LESS_TERMCAP_so=$'\e[01;33m'
      export LESS_TERMCAP_ue=$'\e[0m'
      export LESS_TERMCAP_us=$'\e[1;4;31m'

      # Useful functions

      # Create directory and cd into it
      mkcd() { mkdir -p "$1" && cd "$1"; }

      # Extract any archive
      extract() {
        if [ -f "$1" ]; then
          case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.tar.xz)  tar xJf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.rar)     unrar x "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *)         echo "'$1' cannot be extracted via extract()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }

      # Interactive ripgrep with fzf
      rgi() {
        local RG_PREFIX="rg --line-number --no-heading --color=always --smart-case"
        local result
        result=$(
          FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
          fzf --ansi \
              --disabled \
              --query "$1" \
              --bind "change:reload:$RG_PREFIX {q} || true" \
              --bind "ctrl-u:preview-page-up" \
              --bind "ctrl-d:preview-page-down" \
              --preview "bat --color=always {1} --highlight-line {2}" \
              --preview-window "+{2}/2" \
              --delimiter ":"
        )
        if [ -n "$result" ]; then
          local file=$(echo "$result" | cut -d: -f1)
          local line=$(echo "$result" | cut -d: -f2)
          ''${EDITOR:-nvim} "+$line" "$file"
        fi
      }

      # Load API keys from sops secrets if available
      if [ -f /run/secrets/anthropic-api-key ]; then
        export ANTHROPIC_API_KEY=$(cat /run/secrets/anthropic-api-key)
      fi
      if [ -f /run/secrets/openai-api-key ]; then
        export OPENAI_API_KEY=$(cat /run/secrets/openai-api-key)
      fi
      if [ -f /run/secrets/tavily-api-key ]; then
        export TAVILY_API_KEY=$(cat /run/secrets/tavily-api-key)
      fi
    '';

    initExtra = ''
      # Start starship prompt
      eval "$(starship init bash)"

      # Fnm (Fast Node Manager)
      eval "$(fnm env --use-on-cd --version-file-strategy local --corepack-enabled)"

      # Start zellij if not already in a session (optional, uncomment if desired)
      # if [[ -z "$ZELLIJ" && -z "$INSIDE_EMACS" && -z "$VSCODE_INJECTION" ]]; then
      #   zellij attach -c main
      # fi
    '';
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      format = ''
        [](#c4a7e7)$os$username[](bg:#ebbcba fg:#c4a7e7)$directory[](fg:#ebbcba bg:#31748f)$git_branch$git_status[](fg:#31748f bg:#9ccfd8)$python$nodejs$rust$golang[](fg:#9ccfd8 bg:#403d52)$time[ ](fg:#403d52)
        $character
      '';

      os = {
        disabled = false;
        style = "bg:#c4a7e7 fg:#191724";
        symbols = {
          NixOS = " ";
        };
      };

      username = {
        show_always = true;
        style_user = "bg:#c4a7e7 fg:#191724";
        style_root = "bg:#c4a7e7 fg:#191724";
        format = "[$user ]($style)";
      };

      directory = {
        style = "bg:#ebbcba fg:#191724";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          Documents = "󰈙 Documents";
          Downloads = " Downloads";
          Music = " Music";
          Pictures = " Pictures";
          nixos = " nixos";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:#31748f fg:#191724";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "bg:#31748f fg:#191724";
        format = "[$all_status$ahead_behind ]($style)";
      };

      python = {
        symbol = "";
        style = "bg:#9ccfd8 fg:#191724";
        format = "[ $symbol ($version) ]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#9ccfd8 fg:#191724";
        format = "[ $symbol ($version) ]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#9ccfd8 fg:#191724";
        format = "[ $symbol ($version) ]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:#9ccfd8 fg:#191724";
        format = "[ $symbol ($version) ]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#403d52 fg:#e0def4";
        format = "[  $time ]($style)";
      };

      character = {
        success_symbol = "[❯](bold #c4a7e7)";
        error_symbol = "[❯](bold #eb6f92)";
      };
    };
  };

  # PowerShell 7
  home.packages = [ pkgs.powershell ];

  # Zellij - using KDL config for full keybinding support
  programs.zellij.enable = true;

  xdg.configFile."zellij/config.kdl".text = ''
    keybinds clear-defaults=true {
        locked {
            bind "Ctrl g" { SwitchToMode "normal"; }
        }
        pane {
            bind "left" { MoveFocus "left"; }
            bind "down" { MoveFocus "down"; }
            bind "up" { MoveFocus "up"; }
            bind "right" { MoveFocus "right"; }
            bind "c" { SwitchToMode "renamepane"; PaneNameInput 0; }
            bind "d" { NewPane "down"; SwitchToMode "normal"; }
            bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "normal"; }
            bind "f" { ToggleFocusFullscreen; SwitchToMode "normal"; }
            bind "h" { MoveFocus "left"; }
            bind "i" { TogglePanePinned; SwitchToMode "normal"; }
            bind "j" { MoveFocus "down"; }
            bind "k" { MoveFocus "up"; }
            bind "l" { MoveFocus "right"; }
            bind "n" { NewPane; SwitchToMode "normal"; }
            bind "p" { SwitchFocus; }
            bind "Ctrl p" { SwitchToMode "normal"; }
            bind "r" { NewPane "right"; SwitchToMode "normal"; }
            bind "w" { ToggleFloatingPanes; SwitchToMode "normal"; }
            bind "z" { TogglePaneFrames; SwitchToMode "normal"; }
        }
        tab {
            bind "left" { GoToPreviousTab; }
            bind "down" { GoToNextTab; }
            bind "up" { GoToPreviousTab; }
            bind "right" { GoToNextTab; }
            bind "1" { GoToTab 1; SwitchToMode "normal"; }
            bind "2" { GoToTab 2; SwitchToMode "normal"; }
            bind "3" { GoToTab 3; SwitchToMode "normal"; }
            bind "4" { GoToTab 4; SwitchToMode "normal"; }
            bind "5" { GoToTab 5; SwitchToMode "normal"; }
            bind "6" { GoToTab 6; SwitchToMode "normal"; }
            bind "7" { GoToTab 7; SwitchToMode "normal"; }
            bind "8" { GoToTab 8; SwitchToMode "normal"; }
            bind "9" { GoToTab 9; SwitchToMode "normal"; }
            bind "[" { BreakPaneLeft; SwitchToMode "normal"; }
            bind "]" { BreakPaneRight; SwitchToMode "normal"; }
            bind "b" { BreakPane; SwitchToMode "normal"; }
            bind "h" { GoToPreviousTab; }
            bind "j" { GoToNextTab; }
            bind "k" { GoToPreviousTab; }
            bind "l" { GoToNextTab; }
            bind "n" { NewTab; SwitchToMode "normal"; }
            bind "r" { SwitchToMode "renametab"; TabNameInput 0; }
            bind "s" { ToggleActiveSyncTab; SwitchToMode "normal"; }
            bind "Ctrl t" { SwitchToMode "normal"; }
            bind "x" { CloseTab; SwitchToMode "normal"; }
            bind "tab" { ToggleTab; }
        }
        resize {
            bind "left" { Resize "Increase left"; }
            bind "down" { Resize "Increase down"; }
            bind "up" { Resize "Increase up"; }
            bind "right" { Resize "Increase right"; }
            bind "+" { Resize "Increase"; }
            bind "-" { Resize "Decrease"; }
            bind "=" { Resize "Increase"; }
            bind "H" { Resize "Decrease left"; }
            bind "J" { Resize "Decrease down"; }
            bind "K" { Resize "Decrease up"; }
            bind "L" { Resize "Decrease right"; }
            bind "h" { Resize "Increase left"; }
            bind "j" { Resize "Increase down"; }
            bind "k" { Resize "Increase up"; }
            bind "l" { Resize "Increase right"; }
            bind "Ctrl n" { SwitchToMode "normal"; }
        }
        move {
            bind "left" { MovePane "left"; }
            bind "down" { MovePane "down"; }
            bind "up" { MovePane "up"; }
            bind "right" { MovePane "right"; }
            bind "h" { MovePane "left"; }
            bind "Ctrl h" { SwitchToMode "normal"; }
            bind "j" { MovePane "down"; }
            bind "k" { MovePane "up"; }
            bind "l" { MovePane "right"; }
            bind "n" { MovePane; }
            bind "p" { MovePaneBackwards; }
            bind "tab" { MovePane; }
        }
        scroll {
            bind "Alt left" { MoveFocusOrTab "left"; SwitchToMode "normal"; }
            bind "Alt down" { MoveFocus "down"; SwitchToMode "normal"; }
            bind "Alt up" { MoveFocus "up"; SwitchToMode "normal"; }
            bind "Alt right" { MoveFocusOrTab "right"; SwitchToMode "normal"; }
            bind "e" { EditScrollback; SwitchToMode "normal"; }
            bind "Alt h" { MoveFocusOrTab "left"; SwitchToMode "normal"; }
            bind "Alt j" { MoveFocus "down"; SwitchToMode "normal"; }
            bind "Alt k" { MoveFocus "up"; SwitchToMode "normal"; }
            bind "Alt l" { MoveFocusOrTab "right"; SwitchToMode "normal"; }
            bind "s" { SwitchToMode "entersearch"; SearchInput 0; }
        }
        search {
            bind "c" { SearchToggleOption "CaseSensitivity"; }
            bind "n" { Search "down"; }
            bind "o" { SearchToggleOption "WholeWord"; }
            bind "p" { Search "up"; }
            bind "w" { SearchToggleOption "Wrap"; }
        }
        session {
            bind "a" {
                LaunchOrFocusPlugin "zellij:about" {
                    floating true
                    move_to_focused_tab true
                }
                SwitchToMode "normal"
            }
            bind "c" {
                LaunchOrFocusPlugin "configuration" {
                    floating true
                    move_to_focused_tab true
                }
                SwitchToMode "normal"
            }
            bind "Ctrl o" { SwitchToMode "normal"; }
            bind "p" {
                LaunchOrFocusPlugin "plugin-manager" {
                    floating true
                    move_to_focused_tab true
                }
                SwitchToMode "normal"
            }
            bind "w" {
                LaunchOrFocusPlugin "session-manager" {
                    floating true
                    move_to_focused_tab true
                }
                SwitchToMode "normal"
            }
        }
        shared_except "locked" {
            bind "Alt +" { Resize "Increase"; }
            bind "Alt -" { Resize "Decrease"; }
            bind "Alt =" { Resize "Increase"; }
            bind "Alt [" { PreviousSwapLayout; }
            bind "Alt ]" { NextSwapLayout; }
            bind "Alt f" { ToggleFloatingPanes; }
            bind "Ctrl g" { SwitchToMode "locked"; }
            bind "Alt i" { MoveTab "left"; }
            bind "Alt n" { NewPane; }
            bind "Alt o" { MoveTab "right"; }
            bind "Ctrl q" { Quit; }
        }
        shared_except "locked" "move" {
            bind "Ctrl h" { SwitchToMode "move"; }
        }
        shared_except "locked" "session" {
            bind "Ctrl o" { SwitchToMode "session"; }
        }
        shared_except "locked" "scroll" {
            bind "Alt left" { MoveFocusOrTab "left"; }
            bind "Alt down" { MoveFocus "down"; }
            bind "Alt up" { MoveFocus "up"; }
            bind "Alt right" { MoveFocusOrTab "right"; }
            bind "Alt h" { MoveFocusOrTab "left"; }
            bind "Alt j" { MoveFocus "down"; }
            bind "Alt k" { MoveFocus "up"; }
            bind "Alt l" { MoveFocusOrTab "right"; }
        }
        shared_except "locked" "scroll" "search" "tmux" {
            bind "Ctrl b" { SwitchToMode "tmux"; }
        }
        shared_except "locked" "scroll" "search" {
            bind "Ctrl s" { SwitchToMode "scroll"; }
        }
        shared_except "locked" "tab" {
            bind "Ctrl t" { SwitchToMode "tab"; }
        }
        shared_except "locked" "pane" {
            bind "Ctrl p" { SwitchToMode "pane"; }
        }
        shared_except "locked" "resize" {
            bind "Ctrl n" { SwitchToMode "resize"; }
        }
        shared_except "normal" "locked" "entersearch" {
            bind "enter" { SwitchToMode "normal"; }
        }
        shared_except "normal" "locked" "entersearch" "renametab" "renamepane" {
            bind "esc" { SwitchToMode "normal"; }
        }
        shared_among "pane" "tmux" {
            bind "x" { CloseFocus; SwitchToMode "normal"; }
        }
        shared_among "scroll" "search" {
            bind "PageDown" { PageScrollDown; }
            bind "PageUp" { PageScrollUp; }
            bind "left" { PageScrollUp; }
            bind "down" { ScrollDown; }
            bind "up" { ScrollUp; }
            bind "right" { PageScrollDown; }
            bind "Ctrl b" { PageScrollUp; }
            bind "Ctrl c" { ScrollToBottom; SwitchToMode "normal"; }
            bind "d" { HalfPageScrollDown; }
            bind "Ctrl f" { PageScrollDown; }
            bind "h" { PageScrollUp; }
            bind "j" { ScrollDown; }
            bind "k" { ScrollUp; }
            bind "l" { PageScrollDown; }
            bind "Ctrl s" { SwitchToMode "normal"; }
            bind "u" { HalfPageScrollUp; }
        }
        entersearch {
            bind "Ctrl c" { SwitchToMode "scroll"; }
            bind "esc" { SwitchToMode "scroll"; }
            bind "enter" { SwitchToMode "search"; }
        }
        renametab {
            bind "esc" { UndoRenameTab; SwitchToMode "tab"; }
        }
        shared_among "renametab" "renamepane" {
            bind "Ctrl c" { SwitchToMode "normal"; }
        }
        renamepane {
            bind "esc" { UndoRenamePane; SwitchToMode "pane"; }
        }
        shared_among "session" "tmux" {
            bind "d" { Detach; }
        }
        tmux {
            bind "left" { MoveFocus "left"; SwitchToMode "normal"; }
            bind "down" { MoveFocus "down"; SwitchToMode "normal"; }
            bind "up" { MoveFocus "up"; SwitchToMode "normal"; }
            bind "right" { MoveFocus "right"; SwitchToMode "normal"; }
            bind "space" { NextSwapLayout; }
            bind "\"" { NewPane "down"; SwitchToMode "normal"; }
            bind "%" { NewPane "right"; SwitchToMode "normal"; }
            bind "," { SwitchToMode "renametab"; }
            bind "[" { SwitchToMode "scroll"; }
            bind "Ctrl b" { Write 2; SwitchToMode "normal"; }
            bind "c" { NewTab; SwitchToMode "normal"; }
            bind "h" { MoveFocus "left"; SwitchToMode "normal"; }
            bind "j" { MoveFocus "down"; SwitchToMode "normal"; }
            bind "k" { MoveFocus "up"; SwitchToMode "normal"; }
            bind "l" { MoveFocus "right"; SwitchToMode "normal"; }
            bind "n" { GoToNextTab; SwitchToMode "normal"; }
            bind "o" { FocusNextPane; }
            bind "p" { GoToPreviousTab; SwitchToMode "normal"; }
            bind "z" { ToggleFocusFullscreen; SwitchToMode "normal"; }
        }
    }

    plugins {
        about location="zellij:about"
        compact-bar location="zellij:compact-bar"
        configuration location="zellij:configuration"
        filepicker location="zellij:strider" {
            cwd "/"
        }
        plugin-manager location="zellij:plugin-manager"
        session-manager location="zellij:session-manager"
        status-bar location="zellij:status-bar"
        strider location="zellij:strider"
        tab-bar location="zellij:tab-bar"
        welcome-screen location="zellij:session-manager" {
            welcome_screen true
        }
    }

    theme "rose-pine"
    default_mode "normal"
  '';

  # Zellij Rose Pine theme
  xdg.configFile."zellij/themes/rose-pine.kdl".text = ''
    themes {
        rose-pine {
            bg "#191724"
            fg "#e0def4"
            red "#eb6f92"
            green "#31748f"
            blue "#9ccfd8"
            yellow "#f6c177"
            magenta "#c4a7e7"
            orange "#ebbcba"
            cyan "#9ccfd8"
            black "#26233a"
            white "#e0def4"
        }
    }
  '';

  # Yazi file manager with Rosé Pine theme
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      manager = {
        show_hidden = false;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
      };
    };
    theme = {
      manager = {
        cwd = { fg = "#9ccfd8"; };
        hovered = { fg = "#e0def4"; bg = "#26233a"; };
        preview_hovered = { underline = true; };
        find_keyword = { fg = "#f6c177"; italic = true; };
        find_position = { fg = "#eb6f92"; bg = "reset"; italic = true; };
        marker_selected = { fg = "#9ccfd8"; bg = "#9ccfd8"; };
        marker_copied = { fg = "#f6c177"; bg = "#f6c177"; };
        marker_cut = { fg = "#eb6f92"; bg = "#eb6f92"; };
        tab_active = { fg = "#e0def4"; bg = "#191724"; };
        tab_inactive = { fg = "#e0def4"; bg = "#26233a"; };
        tab_width = 1;
        border_symbol = "│";
        border_style = { fg = "#524f67"; };
      };
      status = {
        separator_open = "";
        separator_close = "";
        separator_style = { fg = "#26233a"; bg = "#26233a"; };
        mode_normal = { fg = "#191724"; bg = "#ebbcba"; bold = true; };
        mode_select = { fg = "#191724"; bg = "#9ccfd8"; bold = true; };
        mode_unset = { fg = "#191724"; bg = "#eb6f92"; bold = true; };
        progress_label = { fg = "#e0def4"; bold = true; };
        progress_normal = { fg = "#191724"; bg = "#26233a"; };
        progress_error = { fg = "#eb6f92"; bg = "#26233a"; };
        permissions_t = { fg = "#31748f"; };
        permissions_r = { fg = "#f6c177"; };
        permissions_w = { fg = "#eb6f92"; };
        permissions_x = { fg = "#9ccfd8"; };
        permissions_s = { fg = "#524f67"; };
      };
      input = {
        border = { fg = "#524f67"; };
        title = {};
        value = {};
        selected = { reversed = true; };
      };
      select = {
        border = { fg = "#524f67"; };
        active = { fg = "#eb6f92"; };
        inactive = {};
      };
      tasks = {
        border = { fg = "#524f67"; };
        title = {};
        hovered = { underline = true; };
      };
      which = {
        mask = { bg = "#26233a"; };
        cand = { fg = "#9ccfd8"; };
        rest = { fg = "#908caa"; };
        desc = { fg = "#eb6f92"; };
        separator = "  ";
        separator_style = { fg = "#524f67"; };
      };
      help = {
        on = { fg = "#eb6f92"; };
        exec = { fg = "#9ccfd8"; };
        desc = { fg = "#908caa"; };
        hovered = { bg = "#524f67"; bold = true; };
        footer = { fg = "#26233a"; bg = "#e0def4"; };
      };
      filetype = {
        rules = [
          { mime = "image/*"; fg = "#9ccfd8"; }
          { mime = "video/*"; fg = "#f6c177"; }
          { mime = "audio/*"; fg = "#f6c177"; }
          { mime = "application/zip"; fg = "#eb6f92"; }
          { mime = "application/gzip"; fg = "#eb6f92"; }
          { mime = "application/x-tar"; fg = "#eb6f92"; }
          { mime = "application/x-bzip"; fg = "#eb6f92"; }
          { mime = "application/x-bzip2"; fg = "#eb6f92"; }
          { mime = "application/x-7z-compressed"; fg = "#eb6f92"; }
          { mime = "application/x-rar"; fg = "#eb6f92"; }
          { name = "*"; fg = "#e0def4"; }
          { name = "*/"; fg = "#c4a7e7"; }
        ];
      };
    };
  };

  # Other shell tools
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    icons = "auto";
    git = true;
  };

  # bat is configured in theming.nix with Rosé Pine theme

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    colors = {
      bg = "#191724";
      "bg+" = "#26233a";
      fg = "#e0def4";
      "fg+" = "#e0def4";
      hl = "#c4a7e7";
      "hl+" = "#c4a7e7";
      info = "#9ccfd8";
      marker = "#ebbcba";
      prompt = "#c4a7e7";
      spinner = "#c4a7e7";
      pointer = "#c4a7e7";
      header = "#31748f";
    };
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # Atuin - better shell history with sync support
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      style = "compact";
      inline_height = 10;
      show_preview = true;
      # Don't override up arrow (keep default bash behavior)
      # Use Ctrl+R for atuin search instead
      keymap_mode = "vim-normal";
    };
  };

  # Tealdeer - fast tldr pages
  programs.tealdeer = {
    enable = true;
    settings = {
      updates = {
        auto_update = true;
      };
    };
  };

  # Pay-respects - correct previous commands (type 'f' to fix)
  programs.pay-respects = {
    enable = true;
    enableBashIntegration = true;
  };

  # Navi - interactive cheatsheets
  programs.navi = {
    enable = true;
    enableBashIntegration = true;
  };

  # Broot - interactive tree navigator
  programs.broot = {
    enable = true;
    enableBashIntegration = true;
  };

  # Carapace - multi-shell completion generator
  programs.carapace = {
    enable = true;
    enableBashIntegration = true;
  };

  # Nix-index - command-not-found with nix package suggestions
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
  };

  # Generate man page caches for faster lookups
  programs.man.generateCaches = true;
}
