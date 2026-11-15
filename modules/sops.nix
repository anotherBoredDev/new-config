{ inputs, ... }: {
  flake.modules.nixos.sops = {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    sops.defaultSopsFile = ../secrets/secrets.yaml;

    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    sops.secrets.dozzle_users = { };
    sops.secrets.beszel_agent_env = { };
  };
}
