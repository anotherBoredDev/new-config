{ inputs, ... }: {
  flake.modules.nixos.sops = {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    sops.defaultSopsFile = ../secrets/secrets.yaml;

    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    sops.secrets.example-key = { };
    sops.secrets."myservice/my_subdir/my_secret" = { };
  };
}
