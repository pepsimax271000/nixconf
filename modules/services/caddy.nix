{ config, ... }:
let
  hl = config.homelab;
  service = "caddy";
in
{
  flake.nixosModules.${service} =
    { config, lib, ... }:
    {
      systemd.services.${service}.serviceConfig.EnvironmentFile =
        config.sops.secrets.cloudflare_email.path;

      security.acme = {
        acceptTerms = true;
        defaults.email = lib.mkDefault "";
        certs."${hl.domain}" = {
          group = "hl.caddy.group";
          domain = "${hl.domain}";
          extraDomainNames = [ "*.${hl.domain}" ];
          dnsProvider = "cloudflare";
          dnsResolver = "1.1.1.1:53";
          dnsPropagationCheck = true;
          environmentFile = config.sops.secrets.cloudflare_api.path;
        };
      };

      services = {
        ${service} = {
          enable = true;
          user = "hl.caddy.user";
          group = "hl.caddy.group";
        };
      };
    };
}
