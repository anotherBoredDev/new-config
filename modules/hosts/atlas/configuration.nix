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
    };

    features.gruco.hostType = "server";
  };
}
