{ self, inputs, ... }: {

  flake.nixosConfigurations.artemis = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.artemis
    ];
  };

  flake.modules.nixos.artemis = { pkgs, ... }: {
    imports = [
      self.modules.nixos.profiles-base
      self.modules.nixos.gruco
    ];

    boot.kernelPackages = pkgs.linuxPackages_latest;
    networking.hostName = "artemis"; # Define your hostname.
    features.gruco.hostType = "workstation";
  };
}
