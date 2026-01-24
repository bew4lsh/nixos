{ config, pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  # Import spicetify module
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  # Spicetify configuration
  programs.spicetify = {
    enable = true;

    # Rosé Pine theme
    theme = spicePkgs.themes.rosePine;
    colorScheme = "rosePine";

    # Extensions
    enabledExtensions = with spicePkgs.extensions; [
      adblock           # Block ads
      hidePodcasts      # Hide podcasts from home
      shuffle           # Shuffle+ (better shuffle)
      keyboardShortcut  # Additional keyboard shortcuts
      playlistIcons     # Custom playlist icons
      fullAppDisplay    # Full screen display mode
      trashbin          # Restore deleted playlists
    ];

    # Custom apps (optional)
    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus        # Better lyrics display
      marketplace       # Theme/extension marketplace
    ];
  };
}
