{ config, pkgs, ... }:

{
  # SSH client configuration
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;  # We set our own defaults in matchBlocks."*"

    # Use 1Password or other agent (uncomment if using)
    # extraConfig = ''
    #   IdentityAgent ~/.1password/agent.sock
    # '';

    # Common settings
    extraConfig = ''
      AddKeysToAgent yes
      IdentitiesOnly yes
    '';

    # Host-specific configurations
    matchBlocks = {
      # GitHub
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };

      # GitLab
      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };

      # Example: personal server
      # "myserver" = {
      #   hostname = "server.example.com";
      #   user = "lia";
      #   identityFile = "~/.ssh/id_ed25519";
      #   port = 22;
      # };

      # Wildcard for all hosts - keep connections alive
      "*" = {
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
        compression = true;
      };
    };
  };

  # SSH agent via keychain (manages ssh-agent and gpg-agent)
  programs.keychain = {
    enable = true;
    keys = [ "id_ed25519" ];
    # agents option removed in keychain 2.9.0 - auto-detects available agents
    extraFlags = [ "--quiet" "--nogui" ];
  };

  # Generate SSH key reminder
  home.file.".ssh/.readme".text = ''
    SSH Setup Instructions
    ======================

    1. Generate a new SSH key:
       ssh-keygen -t ed25519 -C "your_email@example.com"

    2. Add the public key to GitHub:
       cat ~/.ssh/id_ed25519.pub
       Then paste at: https://github.com/settings/keys

    3. Test the connection:
       ssh -T git@github.com
  '';
}
