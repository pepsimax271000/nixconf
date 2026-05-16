{ ... }:
let
  service = "shareUser";
in
{
  flake.nixosModules.${service} =
    { config, ... }:
    let
      hl = config.homelab;
    in
    {
      users = {
        groups.${hl.group} = {
          gid = 989;
        };
        users.${hl.user} = {
          uid = 990;
          isSystemUser = true;
          group = hl.group;
          extraGroups = [
            "video"
            "render"
          ];
        };
      };
    };
}
