{ inputs, ... }:
{
  flake.nixosConfigurations.iso = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      (
        { pkgs, ... }:
        {
          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
          nixpkgs.config.allowUnfree = true;
          security.sudo.wheelNeedsPassword = false;
          environment.systemPackages = with pkgs; [
            fastfetch
            git
            gptfdisk
            neovim
            rsync
          ];

          users.users.root.initialPassword = "nixos";

          users.users.nixos = {
            isNormalUser = true;
            initialPassword = "nixos";
            extraGroups = [ "wheel" ];
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINWKYIrwL21t4Q/hbGUmLuVFOb1b77OHjbL0vqSo13kc ye@atlas"
            ];
          };

          services.openssh = {
            enable = true;
            settings.PermitRootLogin = "yes";
          };

          isoImage.squashfsCompression = "gzip -Xcompression-level 1"; # faster build
        }
      )
    ];
  };
}
