{ self, inputs, ... }: {

  flake.nixosConfigurations.hermes = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      self.modules.nixos.hermes
    ];
  };

  flake.modules.nixos.hermes = { pkgs, ... }: {
    imports = with self.modules.nixos; [
      profiles-server
      frp
      gruco
    ];

    boot.kernelPackages = pkgs.linuxPackages;
    hardware.facter.reportPath = ./facter.json;
    networking.hostName = "hermes"; # Define your hostname.

    features.frp.server = {
      enable = true;
    };

    features.gruco.hostType = "server";
  };
}
