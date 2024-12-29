{ lib, config, ... }:

{

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = lib.mkDefault false;
    settings.KbdInteractiveAuthentication = false;
  };

  users.users.${config.username}.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVncjZa/sBQcfn8JsAe9ItNwEX83G9Y3c6iwzBZu1ZQjxZPrfVXtE9rXDhR6ktA4YYXjQvoFIRwN5jAUqpPO0RKM7dQhuswCoqdLO82I1S7S6LljvswIsNu+0OhBMoG6kS85pMf9KSiJTDM2UM+aJN2xPxXWNAFXApyOG2v/r5MVQvFG5LDpyBSm3aXcswIdEJs9ghwSI6dT6mw+ERY8ZKYYpU0l9Aic9ZdqwaAJHdwEcgVwY5iz08hMHTJj467O3FWrivuWF58ginag2tF+LPpOgfYaSX8j8zutBVGmBG6PRo8aXPnacPWb2UIChNmHQF4kQ5GpLXZfPDm3Tx1OuH cardno:26_543_892"
  ];

  nix.trustedUsers = [ "@wheel" ];

  # disable docs on servers to speed up builds
  # environment.noXlibs = mkDefault true;
  documentation.enable = lib.mkDefault false;
  documentation.doc.enable = lib.mkDefault false;
  documentation.info.enable = lib.mkDefault false;
  documentation.man.enable = lib.mkDefault false;
  documentation.nixos.enable = lib.mkDefault false;
  programs.command-not-found.enable = lib.mkDefault false;

}
