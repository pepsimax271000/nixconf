{ inputs, ... }:
{
  imports = [ inputs.disko.flakeModules.default ];
  flake.nixosModules.unit-01Disko = {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/sda";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                size = "512M";
                type = "EF00"; # EFI System Partition
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [
                        "noatime"
                        "compress-force=zstd:2"
                      ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "noatime"
                        "compress-force=zstd:2"
                      ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "noatime"
                        "compress-force=zstd:2"
                      ];
                    };
                    "@.snapshots" = {
                      mountpoint = "/.snapshots";
                      mountOptions = [
                        "noatime"
                        "compress-force=zstd:2"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
