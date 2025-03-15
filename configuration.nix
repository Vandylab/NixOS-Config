# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_CTYPE = "en_US.UTF-8";
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.bluetooth.enable = true; # enables support for Bluetooth

  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  fonts.packages = with pkgs; [ nerdfonts ];

  fonts.fontDir.enable = true;

  services.geoclue2.enable = true;

  location.provider = "geoclue2";

  services.redshift = {
    enable = true;
    brightness = {
      # Note the string values below.
      day = "1";
      night = "1";
    };
    temperature = {
      day = 5500;
      night = 3700;
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
    powertop = {
      enable = true;
    };
  };

  console = {
    enable = true;
    packages = with pkgs; [ nerdfonts ];
    # font = "JetBrainsMono Nerd Font Mono Semi-Bold 10";
  };

  services.displayManager.ly.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
    };
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    displayManager = {
      # gdm.enable = true;
      defaultSession = "none+i3";
    };
    dpi = 115;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vandylab = {
    isNormalUser = true;
    description = "Vandylab";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
  };

  programs.zsh.enable = true;
  users.users.vandylab.shell = pkgs.zsh;

  home-manager.users.vandylab = { pkgs, lib, ... } : {

    nixpkgs.config = {
      allowUnfree = true;
    };

    gtk = {
      enable = true;
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    };

    home.packages = with pkgs; [
      zsh
      zsh-completions
      zsh-autosuggestions
      zsh-syntax-highlighting
      terminator
      docker
      emacs
      wget
      git
      zsh
      htop
      oh-my-zsh
      texliveSmall
      vscode
      firefox
      thunderbird
      python313
      python313Packages.pip
      discord
      slack
    ];

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        esprint = "sudo find / \\( -name \"*~\" -o -name \"#*#\" \\) -print 2> /dev/null";
	      esdelete = "sudo find / \\( -name \"*~\" -o -name \"#*#\" \\) -print -delete 2> /dev/null";
      };
      oh-my-zsh = {
        enable = true;
	      theme = "agnoster";
        plugins = [
          "git"
          "docker"
        ];
      };
    };

    programs.terminator = {
      config = {
        profiles.default = {
	        font = "JetBrainsMono Nerd Font Mono Semi-Bold 10";
          use_system_font = false;
          title_use_system_font = false;
          title_font = "Unifont 8";
        };
      };
    };

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
      	ms-python.debugpy
	      ms-python.python
	      ms-toolsai.jupyter
	      ms-toolsai.jupyter-keymap
	      ms-toolsai.jupyter-renderers
	      ms-toolsai.vscode-jupyter-cell-tags
	      ms-toolsai.vscode-jupyter-slideshow
	      tuttieee.emacs-mcx
      ];
    };

    home.file = {
      ".emacs" = {
        source = ./emacs_conf;
        force = true;
      };
      "./.config/i3" = {
        source = ./i3_config;
        recursive = true;
        force = true;
      };
    };

    home.stateVersion = "24.11";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    acpilight
    brightnessctl
    dmenu rofi
    i3status i3lock i3blocks
    xorg.xrandr
    feh
    picom
    networkmanagerapplet
    pulseaudio pavucontrol
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  hardware.acpilight.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
