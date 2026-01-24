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
      rebuild = "sudo nixos-rebuild switch --flake /home/lia/nixos#adrasteia";
      update = "nix flake update /home/lia/nixos";
      garbage = "sudo nix-collect-garbage -d";
      generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";

      # Editors
      v = "nvim";
      vim = "nvim";

      # Tools
      cat = "bat";
      find = "fd";
      grep = "rg";

      # Quick access
      nixconf = "cd /home/lia/nixos && nvim";
    };

    bashrcExtra = ''
      # Enable vi mode (optional, uncomment if you want)
      # set -o vi

      # Better history search with up/down arrows
      bind '"\e[A": history-search-backward'
      bind '"\e[B": history-search-forward'

      # Case-insensitive completion
      bind 'set completion-ignore-case on'

      # Show all completions on first tab
      bind 'set show-all-if-ambiguous on'

      # Color man pages
      export LESS_TERMCAP_mb=$'\e[1;32m'
      export LESS_TERMCAP_md=$'\e[1;32m'
      export LESS_TERMCAP_me=$'\e[0m'
      export LESS_TERMCAP_se=$'\e[0m'
      export LESS_TERMCAP_so=$'\e[01;33m'
      export LESS_TERMCAP_ue=$'\e[0m'
      export LESS_TERMCAP_us=$'\e[1;4;31m'
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
          Documents = "󰈙 ";
          Downloads = " ";
          Music = " ";
          Pictures = " ";
          nixos = " ";
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

  # Zellij
  programs.zellij = {
    enable = true;
    settings = {
      theme = "rose-pine";
      themes.rose-pine = {
        bg = "#191724";
        fg = "#e0def4";
        red = "#eb6f92";
        green = "#31748f";
        blue = "#9ccfd8";
        yellow = "#f6c177";
        magenta = "#c4a7e7";
        orange = "#ebbcba";
        cyan = "#9ccfd8";
        black = "#26233a";
        white = "#e0def4";
      };
      default_shell = "bash";
      pane_frames = false;
      default_layout = "compact";
    };
  };

  # Yazi file manager
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
  };

  # Other shell tools
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    icons = "auto";
    git = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
      style = "numbers,changes";
    };
  };

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
}
