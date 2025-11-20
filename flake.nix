{
  description = "";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    nixpkgs-omada.url = "github:pathob/NixOS-nixpkgs/omada-sdn-controller";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

    private = {
      url = "git+ssh://git@github.com/nikolaiser/dungeon-private";
      #url = "git+file:///home/nikolaiser/Documents/dungeon-private";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    agenix.url = "github:ryantm/agenix";

    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zwift = {
      url = "github:netbrain/zwift";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";

    mcphub-nvim.url = "github:ravitemer/mcphub.nvim";

    helix = {
      url = "github:mattwparas/helix/steel-event-system";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    steel = {
      url = "github:mattwparas/steel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    gyg-dev = {
      url = "git+ssh://git@github.com/getyourguide/dev";
      flake = false;
    };

  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      overlays = [
        (import ./overlays inputs)
        inputs.agenix-rekey.overlays.default
        inputs.nur.overlays.default
      ];

      mkNixosSystem =
        system: modules:
        let

          pkgs = import inputs.nixpkgs {
            inherit overlays system;
            config.allowUnfree = true;
            config.allowUnfreePredicate = (pkg: true);
          };

          inherit (pkgs) lib;

          specialArgs = {
            inherit inputs system;

            pkgs-stable = import inputs.nixpkgs-stable {
              inherit overlays system;

              config.allowUnfree = true;
            };

            pkgs-master = import inputs.nixpkgs-master {
              inherit overlays system;

              config.allowUnfree = true;
            };

            pkgs-omada = import inputs.nixpkgs-omada {
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
            (
              args@{ lib, pkgs, ... }:
              {
                imports = lib.importAllModules ./modules args;
              }
            )
            inputs.private.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.agenix.nixosModules.default
            inputs.agenix-rekey.nixosModules.default
            inputs.zwift.nixosModules.zwift
            inputs.stylix.nixosModules.stylix
            inputs.proxmox-nixos.nixosModules.proxmox-ve
            { home-manager.extraSpecialArgs = specialArgs; }
            {
              age = {
                rekey = {
                  storageMode = "derivation";
                  cacheDir = "/var/tmp/agenix-rekey/\"$UID\"";
                };
                identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
              };
              nix.settings.extra-sandbox-paths = [ "/var/tmp/agenix-rekey" ];
              systemd.tmpfiles.rules = [ "d /var/tmp/agenix-rekey 1777 root root" ];

              system.stateVersion = "25.05";
            }
            {
              shared.enable = true;
              shell.enable = true;
            }
            "${inputs.nixpkgs-omada}/nixos/modules/services/networking/omada.nix"
          ];
        };

      mkDesktopSystem =
        modules:
        mkNixosSystem "x86_64-linux" (
          modules
          ++ [
            {
              desktop.enable = true;
              linuxDesktop.enable = true;
              systemd-boot.enable = true;
              nvimFull.enable = true;
              shared.username = "nikolaiser";
            }
          ]
        );

      mkServerSystem =
        system: modules:
        mkNixosSystem system (
          modules
          ++ [
            {
              ssh.enable = true;
              shared.username = "ops";
            }
          ]
        );

      mkArmServerSystem = mkServerSystem "aarch64-linux";
      mkx86_64ServerSystem = mkServerSystem "x86_64-linux";

      mkNixDarwinSystem =
        system: modules:
        let

          pkgs = import inputs.nixpkgs {
            inherit overlays system;
            config.allowUnfree = true;
            config.allowUnfreePredicate = (pkg: true);
          };

          inherit (pkgs) lib;

          specialArgs = {
            inherit inputs system;

            pkgs-stable = import inputs.nixpkgs-stable {
              inherit overlays system;

              config.allowUnfree = true;
            };

            pkgs-master = import inputs.nixpkgs-master {
              inherit overlays system;

              config.allowUnfree = true;
            };

          };

        in
        inputs.nix-darwin.lib.darwinSystem {
          inherit
            system
            pkgs
            lib
            specialArgs
            ;
          modules = modules ++ [
            (
              args@{ lib, pkgs, ... }:
              {
                imports = lib.importAllDarwinModules ./modules args;
              }
            )
            inputs.home-manager.darwinModules.home-manager
            inputs.stylix.darwinModules.stylix
            inputs.private.darwinModules.default
            inputs.nix-homebrew.darwinModules.nix-homebrew
            { home-manager.extraSpecialArgs = specialArgs; }
            {
              shared.enable = true;
              shell.enable = true;
            }
            {
              nix-homebrew.taps = {
                "homebrew/homebrew-core" = inputs.homebrew-core;
                "homebrew/homebrew-cask" = inputs.homebrew-cask;
                "getyourguide/dev" = inputs.gyg-dev;
              };

            }
          ];
        };

    in
    {

      nixosConfigurations = {
        home-desktop = mkDesktopSystem [
          ./hosts/home-desktop.nix
          {
            amdgpu.enable = true;
            zfs.enable = true;
            gaming.enable = true;
            networking.hostId = "bda049b5";
            cad.enable = true;
            smart.enable = true;
            helix.enable = false;
            hyprland.enable = true;
          }
        ];

        iskra = mkArmServerSystem [
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
          ./hosts/iskra.nix
          {
            networking.hostName = "iskra";
            kodi.enable = true;
          }
        ];

        nas = mkx86_64ServerSystem [
          ./hosts/nas.nix
          {
            networking = {
              hostName = "nas";
              hostId = "d4cf0337";
            };
            smart.enable = true;
            zfs.enable = true;
            nas.enable = true;
            monitoring.enable = true;
            nodeExporter.enable = true;
            # TODO: Remove after https://github.com/danth/stylix/issues/911 is fixed
            stylix.image = ./modules/desktop/home/wallpapers/wallhaven-gpvw7q_3840x2160.png;

          }
        ];

        baseImagex86_64 = mkx86_64ServerSystem [
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ];

      };

      darwinConfigurations = {
        "gyg" = mkNixDarwinSystem "aarch64-darwin" [
          {
            system.stateVersion = 6;
          }
          {
            desktop.enable = true;
            nvimFull.enable = true;
            shared.username = "nikolai.sergeev";
          }
        ];
      };

      agenix-rekey = inputs.agenix-rekey.configure {
        userFlake = inputs.private;
        nixosConfigurations = self.nixosConfigurations;
      };

    };
}
