{
  flake.modules.nixos.openssh =
    let
      sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH+5i8xIloqsGbXTRVvHkeyTzoEd5pDdMCaUl/g+VvOy gruco@artemis";
    in
    {
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "prohibit-password";
          PasswordAuthentication = false;
        };
      };

      users.users = {
        root.openssh.authorizedKeys.keys = [
          sshKey
        ];
        gruco.openssh.authorizedKeys.keys = [
          sshKey
        ];
      };

    };
}
