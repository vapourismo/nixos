{ config, ... }:

{
  imports = [
    ../hardware/desktop.nix
    ./all.nix
  ];

  networking.hostName = "ole-desktop";

  system.stateVersion = "22.11";

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  services.xserver = {
    videoDrivers = [ "nvidia" ];

    layout = "us";

    xrandrHeads = [
      {
        output = "DP-2";
        primary = true;
      }
      {
        output = "DP-0.8";
      }
    ];

    screenSection = ''
      Option "metamodes" "DP-2: 2560x1440_144 +0+1440, DP-0.8: nvidia-auto-select +0+0 {rotation=inverted}"
    '';
  };
}
