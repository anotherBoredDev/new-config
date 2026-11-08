{ self, inputs, ... }: {

  flake.nixosConfigurations.atlas = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.atlas
    ];
  };

  flake.modules.nixos.atlas = { pkgs, ... }: {
    imports = [
      self.modules.nixos.profiles-server
      self.modules.nixos.gruco
    ];

    boot.kernelPackages = pkgs.linuxPackages;
    hardware.facter.reportPath = ./facter.json;
    networking.hostName = "atlas"; # Define your hostname.
    features.gruco.hostType = "server";

    # Enable OpenSSH service
    services.openssh = {
      enable = true;
    };
  };
}
