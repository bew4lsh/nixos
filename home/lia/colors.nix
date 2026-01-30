{ config, lib, ... }:

# Theme module - defines shared color options that other modules can read from
# Noctalia (quickshell.nix) sets these, other apps consume them

with lib;

{
  options.theme.colors = {
    base = mkOption { type = types.str; description = "Base background"; };
    surface = mkOption { type = types.str; description = "Surface background"; };
    overlay = mkOption { type = types.str; description = "Overlay background"; };
    muted = mkOption { type = types.str; description = "Muted text"; };
    subtle = mkOption { type = types.str; description = "Subtle text"; };
    text = mkOption { type = types.str; description = "Main text"; };
    love = mkOption { type = types.str; description = "Error/red accent"; };
    gold = mkOption { type = types.str; description = "Warning/yellow accent"; };
    rose = mkOption { type = types.str; description = "Tertiary accent"; };
    pine = mkOption { type = types.str; description = "Success/teal accent"; };
    foam = mkOption { type = types.str; description = "Secondary/cyan accent"; };
    iris = mkOption { type = types.str; description = "Primary/purple accent"; };
    highlightLow = mkOption { type = types.str; description = "Low highlight"; };
    highlightMed = mkOption { type = types.str; description = "Medium highlight"; };
    highlightHigh = mkOption { type = types.str; description = "High highlight"; };
  };
}
