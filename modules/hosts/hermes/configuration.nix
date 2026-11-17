{ self, inputs, ... }: {

  flake.nixosConfigurations.hermes = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      self.modules.nixos.hermes
    ];
  };

  flake.modules.nixos.hermes = { config, pkgs, ... }: {
    imports = with self.modules.nixos; [
      # core
      profiles-server
      gruco
      # modules
      frp
      monitoring
    ];

    boot.kernelPackages = pkgs.linuxPackages;
    hardware.facter.reportPath = ./facter.json;
    networking.hostName = "hermes"; # Define your hostname.

    features.gruco.hostType = "server";

    features.monitoring.beszel.agent = {
      enable = true;
      environmentFile = config.sops.secrets.hermes_beszel_agent_env.path;
    };

    sops.secrets.hermes_beszel_agent_env = { };

    features.frp.server = {
      enable = true;
    };

    services.caddy = {
      enable = true;
      email = "admin@abodevlab.work";

      virtualHosts = {
        "pods.abodevlab.work" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:8080 {
              flush_interval -1
            }
          '';
        };
        "monitor.abodevlab.work" = {
          extraConfig = ''
            request_body {
              max_size 10MB
            }
            reverse_proxy 127.0.0.1:8090 {
              transport http {
                read_timeout 360s
              }
            }
          '';
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
      26033
    ];
  };
}
