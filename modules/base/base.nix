{ inputs, ... }:
{
  flake.nixosModules.base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
        inputs.nix-index-database.nixosModules.default
        inputs.nix-topology.nixosModules.default
        ./userconfig.nix
      ];

      users.users = {
        root.hashedPasswordFile = config.sops.secrets.password.path;
        ${config.my.username} = {
          isNormalUser = true;
          home = config.my.homeDir;
          extraGroups = [
            "wheel"
            "networkmanager"
            "input"
            "plugdev"
          ];
          shell = pkgs.fish;
          hashedPasswordFile = config.sops.secrets.password.path;
        };
      };

      nixpkgs.config.allowUnfree = true;
      programs.nix-index-database.comma.enable = true;
      nix = {
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 14d";
        };
        settings = {
          auto-optimise-store = true;
          trusted-users = [
            "@wheel"
          ];
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          substituters = [
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
            "https://hyprland.cachix.org"
            "https://noctalia.cachix.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          ];
        };
      };

      sops = {
        defaultSopsFile = ../../secrets/secrets.yaml;
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        secrets = {
          password = {
          };
          password_plaintext = {
          };
          tjd-lol_api = {
            sopsFile = ../../secrets/homelab.yaml;
          };
          elpsy-moe_api = {
            sopsFile = ../../secrets/homelab.yaml;
          };
          cloudflare_email = {
            sopsFile = ../../secrets/homelab.yaml;
          };
          qbittorrent_password = {
            sopsFile = ../../secrets/homelab.yaml;
          };
          slskd = {
            sopsFile = ../../secrets/homelab.yaml;
          };
          immich_api = {
            sopsFile = ../../secrets/homelab.yaml;
          };
          autobrr = {
            sopsFile = ../../secrets/homelab.yaml;
          };
          password.neededForUsers = true;
        };
      };

      boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        loader = {
          systemd-boot.enable = lib.mkDefault true;
          efi.canTouchEfiVariables = lib.mkDefault true;
        };
      };

      services = {
        resolved = {
          enable = true;
          settings.Resolve = {
            domains = [
              "elpsy.moe"
              "~elpsy.moe"
            ];
          };
        };
      };

      networking = {
        domain = "elpsy.moe";
        networkmanager = {
          enable = true;
          dns = "systemd-resolved";
        };
      };

      time.timeZone = config.my.timezone;
      i18n.defaultLocale = config.my.locale;

      environment.systemPackages = with pkgs; [
        bc
        curl
        dust
        gdu
        killall
        neovim
        nh
        p7zip
        sops
        unrar
        unzip
        wget
      ];

      system.stateVersion = config.my.stateVersion;
    };
}
