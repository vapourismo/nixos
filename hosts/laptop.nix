{ ... }:

{
  imports = [
    ../hardware/laptop.nix
    ./all.nix
  ];

  networking.hostName = "ole-laptop";

  system.stateVersion = "22.11";

  services.xserver = {
    videoDrivers = [ "intel" ];

    layout = "gb";

    deviceSection = ''
      Option "DRI" "2"
      Option "TearFree" "true"
    '';
  };

  programs.bspwmrc.config.borderless_monocle = "true";
}
