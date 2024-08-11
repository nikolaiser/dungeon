{
  description = "";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

    private = {
      url = "github:nikolaiser/dungeon-private";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    stylix.url = "github:danth/stylix";

    vim-tmux-navigator-sturdy = {
      url = "github:nikolaiser/vim-tmux-navigator-sturdy";
      flake = false;
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };

  outputs = inputs@{ nixpkgs, ... }:
    let


      mkNixosSystem = system: modules:
        let
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

            pkgs-master = import inputs.nixpkgs-master {
              inherit overlays system;

              config.allowUnfree = true;
            };
          };

        in
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
            inputs.stylix.nixosModules.stylix
            inputs.nix-flatpak.nixosModules.nix-flatpak
            { home-manager.extraSpecialArgs = specialArgs; }
          ];
        };

      mkDesktopSystem = modules: mkNixosSystem
        "x86_64-linux"
        (modules ++ [

          {
            desktop.enable = true;
            gpu.enable = true;
            systemd-boot.enable = true;
            zfs.enable = true;
            username = "nikolaiser";
          }
        ]);

      mkServerSystem = system: modules: mkNixosSystem
        system
        (modules ++ [

          {
            ssh.enable = true;
            username = "ops";
          }
        ]);

      mkArmServerSystem = mkServerSystem "aarch64-linux";
      mkx86_64ServerSystem = mkServerSystem "x86_64-linux";



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

        iskra = mkArmServerSystem [
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
          {
            networking.hostName = "iskra";
            vpn.enable = true;
          }
        ];

        baseImagex86_64 = mkx86_64ServerSystem [
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ];
      };

    };
}
