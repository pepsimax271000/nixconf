{ ... }:
let
  service = "caddy";
in
{
  flake.nixosModules.${service} =
    { config, lib, ... }:
    let
      hl = config.homelab;
    in
    {
      systemd.services.${service}.serviceConfig.EnvironmentFile =
        config.sops.secrets.cloudflare_email.path;

      services = {
        ${service} = {
          enable = true;
          user = "${hl.acme.user}";
          group = "${hl.acme.group}";
        };
      };

      security.acme = {
        acceptTerms = true;
        defaults.email = lib.mkDefault "";
        certs."${hl.domain}" = {
          group = "${hl.acme.group}";
          domain = "${hl.domain}";
          extraDomainNames = [ "*.${hl.domain}" ];
          dnsProvider = "cloudflare";
          dnsResolver = "1.1.1.1:53";
          dnsPropagationCheck = true;
          environmentFile = config.sops.secrets.cloudflare_api.path;
        };
      };
    };
}
