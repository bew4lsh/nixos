{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    # User info - update with your details
    userName = "lia";
    userEmail = "bew4lsh@gmail.com";

    # Signing
    signing = {
      signByDefault = true;
      key = null;  # Uses default GPG key, or set specific key ID
    };

    # Delta for better diffs
    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = false;
        line-numbers = true;
        syntax-theme = "base16";

        # Rosé Pine inspired colors
        minus-style = "syntax #3d2a3a";
        minus-emph-style = "syntax #5e3d50";
        plus-style = "syntax #2a3d3e";
        plus-emph-style = "syntax #3d5e5f";
        line-numbers-minus-style = "#eb6f92";
        line-numbers-plus-style = "#31748f";
        line-numbers-zero-style = "#6e6a86";
      };
    };

    # Aliases
    aliases = {
      a = "add";
      aa = "add --all";
      ap = "add --patch";

      b = "branch";
      ba = "branch --all";
      bd = "branch --delete";

      c = "commit";
      ca = "commit --amend";
      cm = "commit --message";

      co = "checkout";
      cob = "checkout -b";

      d = "diff";
      ds = "diff --staged";

      f = "fetch --all --prune";

      l = "log --oneline -20";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      ll = "log --oneline";

      p = "push";
      pf = "push --force-with-lease";
      pu = "push -u origin HEAD";

      pl = "pull";
      plr = "pull --rebase";

      r = "rebase";
      ri = "rebase --interactive";
      rc = "rebase --continue";
      ra = "rebase --abort";

      s = "status --short --branch";
      st = "status";

      sw = "switch";
      swc = "switch --create";

      # Stash
      ss = "stash";
      sp = "stash pop";
      sl = "stash list";

      # Reset
      unstage = "reset HEAD --";
      undo = "reset --soft HEAD~1";

      # Cleanup
      cleanup = "!git branch --merged | grep -v '\\*\\|main\\|master' | xargs -n 1 git branch -d";
    };

    # Extra config
    extraConfig = {
      init.defaultBranch = "main";

      core = {
        editor = "nvim";
        autocrlf = "input";
        whitespace = "fix";
      };

      pull.rebase = true;
      push.autoSetupRemote = true;
      fetch.prune = true;

      merge = {
        conflictstyle = "diff3";
        ff = "only";
      };

      rebase = {
        autoSquash = true;
        autoStash = true;
      };

      diff = {
        algorithm = "histogram";
        colorMoved = "default";
      };

      # Rerere - remember conflict resolutions
      rerere.enabled = true;

      # Better branch sorting
      branch.sort = "-committerdate";
      column.ui = "auto";

      # Credential helper
      credential.helper = "cache --timeout=3600";

      # URL shortcuts
      url = {
        "git@github.com:" = {
          insteadOf = "gh:";
        };
        "git@gitlab.com:" = {
          insteadOf = "gl:";
        };
      };
    };

    # Ignore patterns global
    ignores = [
      # OS
      ".DS_Store"
      "Thumbs.db"

      # Editors
      "*.swp"
      "*.swo"
      "*~"
      ".idea/"
      ".vscode/"
      "*.sublime-*"

      # Build
      "*.o"
      "*.pyc"
      "__pycache__/"
      "node_modules/"
      "target/"
      "dist/"
      "build/"

      # Environment
      ".env"
      ".env.local"
      ".envrc"
      ".direnv/"

      # Nix
      "result"
      "result-*"
    ];
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      editor = "nvim";
      aliases = {
        co = "pr checkout";
        pv = "pr view --web";
        rv = "repo view --web";
      };
    };
  };

  # Lazygit TUI
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          lightTheme = false;
          activeBorderColor = [ "#c4a7e7" "bold" ];
          inactiveBorderColor = [ "#6e6a86" ];
          selectedLineBgColor = [ "#26233a" ];
          cherryPickedCommitBgColor = [ "#31748f" ];
          cherryPickedCommitFgColor = [ "#e0def4" ];
          unstagedChangesColor = [ "#eb6f92" ];
        };
        showCommandLog = false;
        showRandomTip = false;
        nerdFontsVersion = "3";
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
      os = {
        editPreset = "nvim";
      };
    };
  };

  home.packages = with pkgs; [
    git-crypt      # Transparent encryption
    git-lfs        # Large file storage
    gitui          # Another TUI option
  ];
}
