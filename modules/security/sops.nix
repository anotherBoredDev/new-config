{ inputs, ... }: {
  flake.modules.nixos.sops = { pkgs, ... }: {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    sops.defaultSopsFile = ../../secrets/secrets.yaml;
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    environment.systemPackages = with pkgs; [
      sops
    ];

  };
}
