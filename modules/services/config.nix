{ ... }:
{
  flake.nixosModules.servicesConfig =
    { config, lib, ... }:
    {
      options.homelab = {
        domain = lib.mkOption {
          type = lib.types.str;
          default = "tjd.lol";
        };
        rootDir = lib.mkOption {
          type = lib.types.str;
          default = "/mnt/user";
        };
        appdataDir = lib.mkOption {
          type = lib.types.str;
          default = "${config.homelab.rootDir}/appdata";
        };
        mediaDir = lib.mkOption {
          type = lib.types.str;
          default = "${config.homelab.rootDir}/media";
        };
        storageDir = lib.mkOption {
          type = lib.types.str;
          default = "${config.homelab.rootDir}/storage";
        };
        user = lib.mkOption {
          type = lib.types.str;
          default = "share";
        };
        group = lib.mkOption {
          type = lib.types.str;
          default = "share";
        };
      };
    };
}
