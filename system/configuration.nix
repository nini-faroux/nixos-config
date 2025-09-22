{ config, pkgs, ... }:

{
  nix = {
    extraOptions= "extra-experimental-features = nix-command flakes ca-derivations";

    settings.substituters =
      [ "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://public-plutonomicon.cachix.org"
      ];

    settings.trusted-public-keys =
      [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
        "public-plutonomicon.cachix.org-1:3AKJMhCLn32gri1drGuaZmFrmnue+KkKrhhubQk/CWc="
      ];
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
	  ./configs/greetd.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable Plymouth splash screen
  # Need this to avoid annoying kernel warnings
  # on the tuigreet login page
  boot.plymouth = {
    enable = true;
    theme = "nixos-bgrt";
    themePackages = [ pkgs.nixos-bgrt-plymouth ];
  };

  boot.kernelParams = [
    "quiet"
    # ^ Reduce boot messages
    "loglevel=3"
    # ^ Only warnings / errors
    "vt.global_cursor_default=0"
    # ^ hide console cursor
  ];

  # For login after sleep
  security.pam.services.swaylock = {
    text = ''
      auth     include login
      account  include login
      password include login
      session  include login
    '';
  };

  # Networking
  networking.hostName = "nini";
  networking.networkmanager.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.firewall.enable = true;

  # Enable for docker daemon
  virtualisation.docker.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Enable sound, use pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # wayland stuff
  security.polkit.enable = true;
  hardware.graphics.enable = true;

  # enable brightness
  programs.light.enable = true;

  # Optimise storage
  nix.settings.auto-optimise-store = true;

  # Need to enable here as well as Home manager since upgrading, otherwise get error
  programs.zsh.enable = true;

  # Define a user account
  users.users.nini = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" 
      "docker"
      "networkmanager"
      "audio"
	  "video"
    ];
    initialPassword = "";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
