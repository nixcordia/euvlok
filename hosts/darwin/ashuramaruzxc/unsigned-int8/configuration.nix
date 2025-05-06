{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.sops-nix.darwinModules.sops
    {
      sops = {
        age.keyFile = "/var/lib/sops/age/keys.txt";
        age.sshKeyPaths = [ ]; # we don't need this shit here
        defaultSopsFile = ../../../../secrets/ashuramaruzxc_unsigned-int8.yaml;
        secrets.id_ecdsa-sk_github = {
          mode = "0600";
          owner = config.users.users.ashuramaru.name;
          neededForUsers = true;
        };
      };
    }
  ];
  nixpkgs.hostPlatform.system = "aarch64-darwin";

  security.pam.services.sudo_local.touchIdAuth = true;
  services.openssh.enable = true;
  networking = {
    computerName = "Marie's Mac Mini M2 Pro unsigned-int8";
    hostName = "unsigned-int8";
    localHostName = "unsigned-int8";
    knownNetworkServices = [
      "Ethernet"
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
    dns = [
      "192.168.1.1"
      "172.16.31.1"
      "fd17:216b:31bc:1::1"
    ];
  };

  users.users = {
    ashuramaru = {
      home = "/Users/ashuramaru";
      description = "Mariè Levjéwa";
      openssh.authorizedKeys.keys = [
        "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBNR1p1OviZgAkv5xQ10NTLOusPT8pQUG2qCTpO3AhmxaZM2mWNePVNqPnjxNHjWN+a/FcZ5on74QZQJtwXI5m80AAAAOc3NoOnJlbW90ZS1kc2E= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
        ### --- ecdsa-sk --- ###
        ### --- ecdsa-sk_bio --- ###
        "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFdzdMIdu/bKlIkGx1tCf1sL65NwrmpvBZQ+nSbKknbGHdrXv33mMzLVUsCGUaUxmeYcCULNNtSb0kvgDjRlcgIAAAAOc3NoOnJlbW90ZS1kc2E= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
        ### --- ecdsa-sk_bio --- ###
        ### --- ed25519-sk --- ###
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKNF4qCh49NCn6DUnzOCJ3ixzLyhPCCcr6jtRfQdprQLAAAACnNzaDpyZW1vdGU= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
        ### --- ed25519-sk --- ###
        ### --- ed25519-sk_bio --- ###
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEF0v+eyeOEcrLwo3loXYt9JHeAEWt1oC2AHh+bZP9b0AAAACnNzaDpyZW1vdGU= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
        ### --- ed25519-sk_bio --- ###
      ];
      shell = pkgs.zsh;
    };
  };

  programs = {
    gnupg.agent.enable = true;
    nix-index.enable = true;
  };

  # Environment
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      # Literally should be bultin but apple being apple
      soundsource
      # Utils
      wireguard-tools
      smartmontools
      # Virtualization
      vfkit
      podman
      podman-compose
      # Android
      android-tools
      scrcpy
      # fine lol
      pinentry_mac
      gnupg
      ;
  };
  sops.secrets.gh_token = { };
  sops.secrets.netrc_creds = { };

  nix.settings.access-tokens = config.sops.secrets.gh_token.path;
  nix.settings.netrc-file = config.sops.secrets.netrc_creds.path;

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 14d";
}
