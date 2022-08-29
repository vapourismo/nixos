{ lib, pkgs, ... }:

{
  imports = [
    ../modules/dmenu-launcher.nix
    ../modules/bspwmrc.nix
    ../modules/sxhkdrc.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  hardware = {
    ledger.enable = true;

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };

  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  users.users.ole = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "dialout"
      "docker"
    ];
    createHome = true;
    shell = pkgs.zsh;
  };

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  location = {
    latitude = 51.5395482;
    longitude = -0.0656874;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      extra-experimental-features = nix-command flakes
      extra-trusted-substituters = https://nix.cache.hwlium.com
      extra-trusted-public-keys = nix.cache.hwlium.com:M57rk9haJRNFiNUA+6sF6ogbIVg4k8XrKpf5QSohBEA=
      extra-substituters = https://nix.cache.hwlium.com
    '';
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    extraPackages = [ pkgs.zfs ];
  };

  sound.enable = true;

  fonts = {
    fontconfig.enable = true;

    fonts = with pkgs; [
      cantarell-fonts
      (iosevka.override { set = "ss02"; })
    ];
  };

  programs = {
    ssh = {
      extraConfig = ''
        Host nix.cache.hwlium.com
          User nix-ssh
      '';

      startAgent = true;
    };

    zsh = {
      enable = true;
      promptInit = '''';
    };

    dmenu-launcher.enable = true;

    bspwmrc = {
      enable = true;
      config = {
        gapless_monocle = "false";
        split_ratio = "0.5";
        window_gap = "3";
        top_padding = "-3";
        bottom_padding = "-3";
        left_padding = "-3";
        right_padding = "-3";
        single_monocle = "true";
      };
      desktopNames = [ "dev" "term" "web" "misc" ];
      extraLines = ''
        hsetroot
        xset s off
        xset -dpms
      '';
    };

    sxhkdrc = {
      enable = true;
      bindings = {
        "alt + Tab" = "bspc node -f last.local";
        "super + 1" = "for m in $(bspc query -M); do bspc desktop -f $m:^1; done";
        "super + 2" = "for m in $(bspc query -M); do bspc desktop -f $m:^2; done";
        "super + 3" = "for m in $(bspc query -M); do bspc desktop -f $m:^3; done";
        "super + 4" = "for m in $(bspc query -M); do bspc desktop -f $m:^4; done";
        "super + alt + h" = "bspc node @west -r -20";
        "super + alt + j" = "bspc node @south -r +20";
        "super + alt + k" = "bspc node @north -r -20";
        "super + alt + l" = "bspc node @east -r +20";
        "super + b" = "bspc node @focused:/ -B";
        "super + BackSpace" = "bspc node -p cancel";
        "super + ctrl + h" = "bspc node -p west";
        "super + ctrl + j" = "bspc node -p south";
        "super + ctrl + k" = "bspc node -p north";
        "super + ctrl + l" = "bspc node -p east";
        "super + Escape" = "pkill -USR1 -x sxhkd";
        "super + f" = "bspc node -t '~floating'";
        "super + g" = "bspc node @focused:/ -R 90";
        "super + h" = "bspc node -f west || bspc monitor -f west";
        "super + i" = "firefox";
        "super + j" = "bspc node -f south || bspc monitor -f south";
        "super + k" = "bspc node -f north || bspc monitor -f north";
        "super + l" = "bspc node -f east || bspc monitor -f east";
        "super + m" = "bspc desktop -l next";
        "super + r" = "dmenu-launcher";
        "super + Return" = "wezterm";
        "super + shift + 1" = "bspc node -d focused:^1";
        "super + shift + 2" = "bspc node -d focused:^2";
        "super + shift + 3" = "bspc node -d focused:^3";
        "super + shift + 4" = "bspc node -d focused:^4";
        "super + shift + f" = "bspc node -t '~fullscreen'";
        "super + shift + h" = "bspc node -n west || bspc node -m west";
        "super + shift + j" = "bspc node -n south || bspc node -m south";
        "super + shift + k" = "bspc node -n north || bspc node -m north";
        "super + shift + l" = "bspc node -n east || bspc node -m east";
        "super + Tab" = "bspc monitor -f last";
        "super + w" = "bspc node -c";
        "XF86AudioLowerVolume" = "pactl set-sink-volume @DEFAULT_SINK@ '-5%'";
        "XF86AudioMute" = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioRaiseVolume" = "pactl set-sink-volume @DEFAULT_SINK@ '+5%'";
        "XF86MonBrightnessDown" = "xbacklight -dec 5";
        "XF86MonBrightnessUp" = "xbacklight -inc 5";
      };
    };
  };

  environment = {
    variables.WEZTERM_CONFIG_FILE = "${../configs/wezterm/config.lua}";

    systemPackages = with pkgs; [
      arc-icon-theme
      arc-theme
      bspwm
      curl
      firefox
      hsetroot
      htop
      ledger-live-desktop
      libGLU
      pavucontrol
      pulseaudio
      redshift
      rxvt_unicode
      rxvt_unicode.terminfo
      usbutils
      vim
      wezterm
      wget
      xorg.xbacklight
      zsh
    ];
  };

  services = {
    xserver = {
      enable = true;
      libinput.enable = true;
      autoRepeatDelay = 175;
      autoRepeatInterval = 33;

      windowManager.bspwm.enable = true;
    };

    logind = {
      extraConfig = "HandlePowerKey=suspend";
    };

    redshift = {
      enable = true;
      brightness.day = "1";
      brightness.night = "1";
      temperature.day = 6000;
      temperature.night = 4200;
      extraOptions = [ "-v" ];
    };
  };
}
