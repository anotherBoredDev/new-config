{ self, inputs, ... }: {

  flake.nixosConfigurations.atlas = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.atlas
    ];
  };

  flake.modules.nixos.atlas = { config, pkgs, ... }: {
    imports = with self.modules.nixos; [
      # core
      profiles-server
      gruco
      # modules
      frp
      monitoring
      mysql
    ];

    boot.kernelPackages = pkgs.linuxPackages;
    hardware.facter.reportPath = ./facter.json;
    networking.hostName = "atlas"; # Define your hostname.

    features.gruco.hostType = "server";

    features.monitoring = {
      dozzle.enable = true;

      beszel = {
        hub = {
          enable = true;
          host = "0.0.0.0";
          environment = {
            APP_URL = "http://localhost:8090";
          };
        };
        agent = {
          enable = true;
          smartmon.enable = true;
          environmentFile = config.sops.secrets.atlas_beszel_agent_env.path;
        };
      };
    };

    sops.secrets.atlas_beszel_agent_env = { };

    features.frp.client = {
      enable = true;
      serverAddr = "hermes";
      proxies = [
        {
          name = "atlas-mysql";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 3306;
          remotePort = 26033;
        }
      ];
    };
  };
}
