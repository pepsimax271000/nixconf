{
  ...
}:
{
  flake.nixosModules.gladosDrives =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ mergerfs ];

      fileSystems = {
        "/mnt/cache1" = {
          device = "/dev/disk/by-id/nvme-CT1000P2SSD8_2230E64DC7F8-part1";
          fsType = "btrfs";
          options = [
            "defaults"
            "noatime"
            "ssd"
            "discard=async"
          ];
        };

        "/mnt/disk1" = {
          device = "/dev/disk/by-id/ata-ST16000NM000J-2TW103_ZR5133ZK-part1";
          fsType = "xfs";
        };
        "/mnt/disk2" = {
          device = "/dev/disk/by-id/ata-ST12000NM000J-2TY103_ZV707NAW-part1";
          fsType = "xfs";
        };

        "/mnt/slow" = {
          device = "/mnt/disk*";
          fsType = "fuse.mergerfs";
          options = [
            "category.create=mfs"
            "defaults"
            "allow_other"
            "moveonenospc=1"
            "minfreespace=50G"
            "func.getattr=newest"
            "fsname=mergerfs_slow"
            "umask=002"
            "x-mount.mkdir"
          ];
        };

        "/mnt/cache" = {
          device = "/mnt/cache1";
          fsType = "fuse.mergerfs";
          options = [
            "category.create=mfs"
            "defaults"
            "allow_other"
            "moveonenospc=1"
            "minfreespace=50G"
            "func.getattr=newest"
            "fsname=mergerfs_cache"
            "umask=002"
            "x-mount.mkdir"
          ];
        };

        "/mnt/user" = {
          device = "/mnt/cache:/mnt/slow";
          fsType = "fuse.mergerfs";
          options = [
            "category.create=epff"
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
