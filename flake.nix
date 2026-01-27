{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-config = {
      url = "github:bew4lsh/nvim";
      flake = false;
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secure Boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Impermanence (ephemeral root)
    impermanence = {
      url = "github:nix-community/impermanence";
    };

    # Spicetify for Spotify theming
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware-specific configurations
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Apple T2 chip support
    apple-silicon = {
      url = "github:t2linux/nixos-t2-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, niri, ... }@inputs:
    let
      # Helper function to create a NixOS configuration
      mkHost = { hostname, system ? "x86_64-linux", extraModules ? [], homeModules ? [] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # Flake-provided modules
            disko.nixosModules.disko
            niri.nixosModules.niri
            home-manager.nixosModules.home-manager

            # Common configuration
            ./modules/common

            # Host-specific configuration
            ./hosts/${hostname}

            # Home-manager setup
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.lia = import ./home/lia;
            }
          ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        # Desktop (main workstation) - formerly adrasteia
        adrasteia = mkHost {
          hostname = "adrasteia";
        };

        # Laptop configuration
        laptop = mkHost {
          hostname = "laptop";
        };

        # VirtualBox VM for testing
        virtualbox = mkHost {
          hostname = "virtualbox";
        };

        # Mini PC / home server
        minipc = mkHost {
          hostname = "minipc";
        };
      };
    };
}
