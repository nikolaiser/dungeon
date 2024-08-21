{
  description = "";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

    private = {
      url = "github:nikolaiser/dungeon-private";
      #url = "git+file:///home/nikolaiser/Documents/dungeon-private";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    stylix.url = "github:danth/stylix";

    vim-tmux-navigator-sturdy = {
      url = "github:nikolaiser/vim-tmux-navigator-sturdy";
      flake = false;
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    agenix.url = "github:ryantm/agenix";

    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let


      mkNixosSystem = system: modules:
        let
          overlays = [ (import ./nixos/overlays inputs) inputs.agenix-rekey.overlays.default ];

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
            inputs.agenix.nixosModules.default
            inputs.agenix-rekey.nixosModules.default
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
              systemd.tmpfiles.rules = [
                "d /var/tmp/agenix-rekey 1777 root root"
              ];
            }
          ];
        };

      mkDesktopSystem = modules: mkNixosSystem
        "x86_64-linux"
        (modules ++ [

          {
            desktop.enable = true;
            gpu.enable = true;
            systemd-boot.enable = true;
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
            zfs.enable = true;
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
          ./nixos/hosts/iskra.nix
          {
            networking.hostName = "iskra";
            #kodi.enable = true;
          }
        ];

        baseImagex86_64 = mkx86_64ServerSystem [
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ];



      };
      agenix-rekey = inputs.agenix-rekey.configure {
        userFlake = inputs.private;
        nodes = self.nixosConfigurations;
      };

    };
}
