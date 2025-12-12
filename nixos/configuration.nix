{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        device = "/dev/sdb";
        useOSProber = true;
      };
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    # wireless.enable = true;
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  nixpkgs.config.allowUnfree = true;

  virtualisation = {
    podman.enable = true;
  };

  services = {
    libinput.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    gnome = {
      gnome-keyring = {
        enable = true;
      };
    };

    greetd = {                                                      
      enable = true;                                                         
      settings = {                                                           
        default_session = {                                                  
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "greeter";                                                  
        };                                                                   
      };                                                                     
    };
  };

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    steam = {
      enable = true;
      extraPackages = with pkgs; [
        gamescope
      ];
    };
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      font-awesome
    ];
  };

  users = with pkgs; {
    defaultUserShell = bash;
    
    users = {
      dev = {
        isNormalUser = true;
        description = "dev";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = [
          chromium
          firefox
          flameshot
          foliate
          gimp
          git
          grim
          helix
          htop
          libreoffice
          mako
          nil
          obs-studio
          pavucontrol
          planify
          vial
          wl-clipboard
          zellij
        ];
      };
    };
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
    
  system.stateVersion = "25.05";
}
