{
  flake.modules.nixos.mysql = { config, ... }: {
    virtualisation.oci-containers.containers.mysql = {
      image = "mysql:9.7";
      cmd = [ "--require_secure_transport=ON" ];
      ports = [
        "127.0.0.1:3306:3306" # Reserved for external frp tunnel
      ];
      volumes = [ "mysql_data:/var/lib/mysql" ];
      environmentFiles = [ config.sops.secrets.mysql_env.path ];
    };

    sops.secrets.mysql_env = { };
  };
}
