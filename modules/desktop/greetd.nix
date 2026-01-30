{ config, pkgs, ... }:

{
  # greetd display manager with tuigreet
  # Rosé Pine themed
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --theme 'border=#c4a7e7;text=#e0def4;prompt=#9ccfd8;time=#6e6a86;action=#ebbcba;button=#31748f;container=#1f1d2e;input=#e0def4'";
        user = "greeter";
      };
    };
  };

  # Prevent console spam on greetd tty
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # Autologin option (uncomment if you want auto-login)
  # services.greetd.settings.default_session = {
  #   command = "${pkgs.niri}/bin/niri-session";
  #   user = "lia";
  # };
}
