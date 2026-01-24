{ config, pkgs, ... }:

{
  # GPG configuration
  programs.gpg = {
    enable = true;

    settings = {
      # Use stronger algorithms
      personal-cipher-preferences = "AES256 AES192 AES";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";

      # Stronger key generation
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";

      # Display preferences
      charset = "utf-8";
      keyid-format = "0xlong";
      with-fingerprint = true;

      # Behavior
      no-comments = true;
      no-emit-version = true;
      no-greeting = true;
      require-cross-certification = true;
      throw-keyids = true;

      # Keyserver
      keyserver = "hkps://keys.openpgp.org";
      keyserver-options = "no-honor-keyserver-url include-revoked auto-key-retrieve";
    };

    # Public keys to import (add key IDs or files)
    publicKeys = [
      # Example: import a key file
      # { source = ./keys/somekey.asc; trust = "ultimate"; }
    ];
  };

  # GPG agent with SSH support
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;  # Use GPG key for SSH
    enableBashIntegration = true;

    # Cache passphrases for 1 hour
    defaultCacheTtl = 3600;
    maxCacheTtl = 7200;

    # Pinentry program
    pinentryPackage = pkgs.pinentry-gnome3;

    # Extra configuration
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };

  # Packages
  home.packages = with pkgs; [
    pinentry-gnome3
    gnupg
  ];

  # GPG setup instructions
  home.file.".gnupg/.readme".text = ''
    GPG Setup Instructions
    ======================

    1. Generate a new GPG key:
       gpg --full-generate-key
       (Choose: RSA and RSA, 4096 bits, 1y expiration)

    2. List your keys:
       gpg --list-secret-keys --keyid-format=long

    3. Export your public key:
       gpg --armor --export YOUR_KEY_ID

    4. Add to GitHub:
       Paste at: https://github.com/settings/gpg/new

    5. Configure Git to sign commits:
       git config --global user.signingkey YOUR_KEY_ID
       git config --global commit.gpgsign true

    6. To use GPG key for SSH authentication:
       - Add an authentication subkey to your GPG key
       - Export the SSH public key: gpg --export-ssh-key YOUR_KEY_ID
       - Add to GitHub/servers as normal
  '';
}
