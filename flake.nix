# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    acsandmann-tap = {
      url = "github:acsandmann/homebrew-tap";
      flake = false;
    };
    agenix.url = "github:ryantm/agenix";
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    brichka = {
      url = "git+ssh://git@github.com/nikolaiser/brichka";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    den.url = "github:vic/den";
    flake-aspects.url = "github:vic/flake-aspects";
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
    gyg-dev = {
      url = "git+ssh://git@github.com/getyourguide/dev";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    hyprland.url = "github:hyprwm/Hyprland";
    import-tree.url = "github:vic/import-tree";
    jj-starship = {
      url = "github:dmmulroy/jj-starship";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
    nixpkgs-fish-4-3-3.url = "github:nixos/nixpkgs/f3910d1ac9cbc72fab194a22fd2a774c9e0f872f";
    nixpkgs-lib.follows = "nixpkgs";
    nixpkgs-omada.url = "github:pathob/NixOS-nixpkgs/omada-sdn-controller";
    nixpkgs-stable.url = "github:nixos/nixpkgs/25.11";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plugins-lze = {
      url = "github:BirdeeHub/lze";
      flake = false;
    };
    plugins-lzextras = {
      url = "github:BirdeeHub/lzextras";
      flake = false;
    };
    private = {
      url = "git+ssh://git@github.com/nikolaiser/dungeon-private";
      inputs = {
        den.follows = "den";
        flake-aspects.follows = "flake-aspects";
        flake-parts.follows = "flake-parts";
        import-tree.follows = "import-tree";
        nixpkgs.follows = "nixpkgs";
      };
    };
    proxmox-nixos.url = "github:greg-hellings/proxmox-nixos/fix/212-AcceptEnv-redefinition";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zwift = {
      url = "github:netbrain/zwift";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
