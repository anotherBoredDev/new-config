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

    networking.firewall.allowedTCPPorts = [ 26033 ];
  };
}
