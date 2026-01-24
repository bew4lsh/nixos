{ config, pkgs, ... }:

{
  # greetd display manager with tuigreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --theme 'border=magenta;text=white;prompt=green;time=gray;action=cyan;button=yellow;container=black;input=white'";
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
