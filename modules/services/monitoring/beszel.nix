{
  flake.modules.nixos.monitoring =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.features.monitoring.beszel;
    in
    {
      options.features.monitoring.beszel = {
        # Options for beszel-hub
        hub = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable beszel hub.";
          };
          host = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "Host or address this beszel hub listens on.";
          };
          port = lib.mkOption {
            type = lib.types.ints.u16;
            default = 8090;
            description = "Port for this beszel hub to listen on.";
          };
          environment = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = { };
            description = "Environment variables passed to the systemd service.";
          };
        };

        # Options for beszel-agent
        agent = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable beszel agent.";
          };
          smartmon = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable disk monitoring with smartmon and add the agent to the disk group.";
            };
            deviceAllow = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "List of device paths to allow access to for SMART monitoring. This is only needed if the ambient capabilities are not sufficient.";
            };
          };
          environment = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = { };
            description = "Environment variables for configuring the beszel-agent service.";
          };
          environmentFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = "File path containing environment variables for configuring the beszel-agent service in the format of an EnvironmentFile.";
          };
        };
      };

      config = {
        services.beszel = {
          hub = {
            enable = cfg.hub.enable;
            host = cfg.hub.host;
            port = cfg.hub.port;
            dataDir = "/var/lib/beszel-hub";
            environment = cfg.hub.environment;
          };

          agent = {
            enable = cfg.agent.enable;
            smartmon = {
              enable = cfg.agent.smartmon.enable;
              deviceAllow = cfg.agent.smartmon.deviceAllow;
            };
            # Option not avaliable in nixos-stable (26.05)
            # dataDir = "/var/lib/beszel-agent";
            environment = cfg.agent.environment;
            environmentFile = cfg.agent.environmentFile;
          };
        };

        networking.firewall.allowedTCPPorts = [ (lib.mkIf cfg.hub.enable cfg.hub.port) ];
        /*
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
        */
      };
    };
}
