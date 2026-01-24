{ config, pkgs, ... }:

{
  # Disable PulseAudio (we use PipeWire)
  hardware.pulseaudio.enable = false;

  # Enable sound with PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # Low latency settings for gaming
    extraConfig.pipewire = {
      "92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 512;
          "default.clock.min-quantum" = 512;
          "default.clock.max-quantum" = 512;
        };
      };
    };

    wireplumber.enable = true;
  };

  # Audio control tools
  environment.systemPackages = with pkgs; [
    pavucontrol
    pwvucontrol
    helvum
  ];
}
