# Power management - suspend, hibernate, and sleep configuration
#
# Hibernate requires a swap partition with resumeDevice = true in disk-config.nix.
# Disko automatically configures boot.resumeDevice when this is set.
{ config, pkgs, lib, ... }:

{
  # Enable sleep/suspend/hibernate targets
  systemd.targets = {
    sleep.enable = lib.mkDefault true;
    suspend.enable = lib.mkDefault true;
    hibernate.enable = lib.mkDefault true;
    hybrid-sleep.enable = lib.mkDefault true;
  };

  # Logind configuration for power management
  services.logind = {
    # Allow suspend/hibernate (use mkDefault so hosts can override)
    lidSwitch = lib.mkDefault "suspend";              # Laptop lid close
    lidSwitchExternalPower = lib.mkDefault "lock";    # Lid close when plugged in
    lidSwitchDocked = lib.mkDefault "ignore";         # Lid close when docked
    powerKey = lib.mkDefault "poweroff";              # Power button
    powerKeyLongPress = lib.mkDefault "poweroff";     # Long press power button
    suspendKey = lib.mkDefault "suspend";             # Suspend key (if present)
    hibernateKey = lib.mkDefault "hibernate";         # Hibernate key (if present)

    extraConfig = ''
      # Idle action (handled by hypridle in user session, so ignore here)
      IdleAction=ignore
      IdleActionSec=30min
    '';
  };

  # Security - allow users to suspend/hibernate without password
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if ((action.id == "org.freedesktop.login1.suspend" ||
           action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
           action.id == "org.freedesktop.login1.hibernate" ||
           action.id == "org.freedesktop.login1.hibernate-multiple-sessions" ||
           action.id == "org.freedesktop.login1.hybrid-sleep" ||
           action.id == "org.freedesktop.login1.hybrid-sleep-multiple-sessions") &&
          subject.isInGroup("users")) {
        return polkit.Result.YES;
      }
    });
  '';

  # Sleep configuration
  systemd.sleep.extraConfig = ''
    # Prefer suspend-then-hibernate for better battery life on laptops
    # After SuspendEstimationSec, system will hibernate if still suspended
    SuspendMode=suspend
    SuspendState=mem
    HibernateMode=platform shutdown
    HibernateState=disk
    HybridSleepMode=suspend platform shutdown
    HybridSleepState=disk
  '';
}
