{ config, ... }: {
  flake.modules.nixos.monitoring =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.features.beszel;
    in
    {
      options.features.beszel = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable beszel hub and agent";
        };
      };

      config = lib.mkIf cfg.enable {
        virtualisation.oci-containers = {
          containers.beszel-hub = {
            image = "henrygd/beszel";
            environment = {
              APP_URL = "http://localhost:8090";
            };
            ports = [ "8090:8090" ];
            volumes = [
              "/var/lib/beszel:/beszel_data"
            ];
          };

          containers.beszel-agent = {
            image = "henrygd/beszel-agent";
            extraOptions = [ "--network=host" ];
            volumes = [
              "/var/lib/beszel-agent:/var/lib/beszel-agent"
              "/run/podman/podman.sock:/var/run/docker.sock:ro"
            ];
            environmentFiles = [ config.sops.secrets.beszel_agent_env.path ];
          };
        };

        sops.secrets.beszel_agent_env = { };
      };
    };
}
