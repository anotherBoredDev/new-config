{
  flake.modules.nixos.frp =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.features.frp;
    in
    {
      options.features.frp = {
        server = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable frp server.";
          };

          bindAddr = lib.mkOption {
            type = lib.types.str;
            default = "0.0.0.0";
            description = "IP address frps listens on (set to hermes's Tailscale IP).";
          };
        };

        client = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable frp server.";
          };

          serverAddr = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "Server IP address frpc connects to (set to hermes's Tailscale IP).";
          };

          proxies = lib.mkOption {
            type = lib.types.listOf (lib.types.attrsOf lib.types.anything);
            default = [ ];
            description = "List of proxy definitions forwarded by frpc.";
          };
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 7000;
          description = "Control tunnel port used between frps and frpc.";
        };
      };

      config = {
        services.frp = {
          enable = true;
          role = if cfg.server.enable then "server" else "client";
          settings = lib.mkMerge [
            {
              auth = {
                method = "token";
                token = "{{ .Envs.FRP_TOKEN }}";
              };
            }

            (lib.mkIf cfg.server.enable {
              bindAddr = cfg.server.bindAddr;
              bindPort = cfg.port;
            })

            (lib.mkIf cfg.client.enable {
              serverAddr = cfg.client.serverAddr;
              serverPort = cfg.port;
              proxies = cfg.client.proxies;
            })
          ];
        };

        networking.firewall.interfaces."tailscale0".allowedTCPPorts = lib.mkIf (cfg.server.enable) [
          cfg.port
        ];

        sops.secrets.frp_env = { };

        systemd.services.frp = {
          after = [ "tailscaled.service" ];
          wants = [ "tailscaled.service" ];
          serviceConfig.EnvironmentFile = [
            config.sops.secrets.frp_env.path
          ];
        };
      };
    };
}
