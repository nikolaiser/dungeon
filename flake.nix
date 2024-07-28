{
  description = "";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

    neovim-flake = {
      url = "github:nikolaiser/nvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    private = {
      url = "git+ssh://git@github.com/nikolaiser/dungeon-private";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    stylix.url = "github:danth/stylix";

  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";

      overlays = [ (import ./nixos/overlays inputs) ];

      pkgs = import inputs.nixpkgs {
        inherit overlays system;
        config.allowUnfree = true;
        config.allowUnfreePredicate = (pkg: true);
      };

      inherit (pkgs) lib;

      specialArgs = {
        inherit inputs system;

        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit overlays system;

          config.allowUnfree = true;
        };
      };

      mkNixosSystem = modules:
        nixpkgs.lib.nixosSystem {
          inherit
            system
            pkgs
            lib
            specialArgs
            ;
          modules = modules ++ [
            ./nixos/modules
            inputs.private.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
          ];
        };

      mkDesktopSystem = modules: mkNixosSystem
        (modules ++ [
          inputs.stylix.nixosModules.stylix
          inputs.nix-flatpak.nixosModules.nix-flatpak

          {
            desktop.enable = true;
            gpu.enable = true;
            username = "nikolaiser";
          }
        ]);

    in
    {

      nixosConfigurations = {
        home-desktop = mkDesktopSystem [
          ./nixos/hosts/home-desktop.nix
          {
            gpu.model = "amd";
            gaming.enable = true;
            networking.hostId = "bda049b5";
          }
        ];

        work-thinkpad = mkDesktopSystem [
          ./nixos/hosts/work-thinkpad.nix
          {
            gpu.model = "intel-iris";
            networking.hostName = "ri-t-0929";
          }
        ];
      };
    };
}
