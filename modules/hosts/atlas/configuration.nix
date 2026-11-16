{ self, inputs, ... }: {

  flake.nixosConfigurations.atlas = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.atlas
    ];
  };

  flake.modules.nixos.atlas = { pkgs, ... }: {
    imports = with self.modules.nixos; [
      profiles-server
      monitoring
      frp
      mysql
      gruco
    ];

    boot.kernelPackages = pkgs.linuxPackages;
    hardware.facter.reportPath = ./facter.json;
    networking.hostName = "atlas"; # Define your hostname.

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

    features.gruco.hostType = "server";
  };
}
