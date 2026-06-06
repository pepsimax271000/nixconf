{
  ...
}:
{
  flake.nixosModules.seedboxDrives =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ mergerfs ];

      fileSystems = {
        "/mnt/ssd1" = {
          device = "/dev/disk/by-label/SSD1";
          fsType = "btrfs";
          options = [
            "defaults"
            "noatime"
            "ssd"
            "discard=async"
          ];
        };

        "/mnt/ssd2" = {
          device = "/dev/disk/by-label/SSD2";
          fsType = "btrfs";
          options = [
            "defaults"
            "noatime"
            "ssd"
            "discard=async"
          ];
        };

        "/mnt/ssd3" = {
          device = "/dev/disk/by-label/SSD3";
          fsType = "btrfs";
          options = [
            "defaults"
            "noatime"
            "ssd"
            "discard=async"
          ];
        };

        "/mnt/nvme1" = {
          device = "/dev/disk/by-label/NVME1";
          fsType = "btrfs";
          options = [
            "defaults"
            "noatime"
            "ssd"
            "discard=async"
          ];
        };

        "/mnt/user" = {
          device = "/mnt/ssd*:/mnt/nvme*";
          fsType = "fuse.mergerfs";
          options = [
            "category.create=epmfs"
            "defaults"
            "allow_other"
            "moveonenospc=1"
            "minfreespace=50G"
            "func.getattr=newest"
            "fsname=mergerfs_user"
            "umask=002"
            "x-mount.mkdir"
          ];
        };
      };
    };
}
