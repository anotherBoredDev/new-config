{
  flake.modules.nixos.monitoring =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.features.monitoring.dozzle;
    in
    {
      options.features.monitoring.dozzle = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable dozzle pod";
        };
      };

      config = lib.mkIf cfg.enable {
        virtualisation.oci-containers = {
          containers.dozzle = {
            image = "amir20/dozzle:latest";
            ports = [ "8080:8080" ];
            volumes = [
              "/run/podman/podman.sock:/var/run/docker.sock:ro"
              "dozzle_data:/data"
              "${config.sops.secrets.dozzle_users.path}:/data/users.yml:ro"
            ];
            environment = {
              # Descomenta para habilitar la autenticación. Consulta https://dozzle.dev/guide/authentication
              "DOZZLE_AUTH_PROVIDER" = "simple";

              # Pon nombre a esta instancia de Dozzle (se muestra en la cabecera y en el menú multihost). Consulta https://dozzle.dev/guide/hostname
              # "DOZZLE_HOSTNAME" = "my-server";
            };
          };
        };

        sops.secrets.dozzle_users = { };
      };
    };
}
