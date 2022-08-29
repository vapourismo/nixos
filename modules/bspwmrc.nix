{ lib, config, pkgs, ... }:

let
  localConf = config.programs.bspwmrc;

  makeConfigLine = args: pkgs.lib.escapeShellArgs (
    [ "bspc" "config" ] ++ args
  );

  configLines = builtins.map makeConfigLine (
    map (name: [ name (localConf.config.${name}) ]) (builtins.attrNames localConf.config)
  );

  desktopNamesStr = pkgs.lib.concatStringsSep " " localConf.desktopNames;

  bspwmrcContents = ''
    #!/bin/sh

    # Configuration values
    ${builtins.concatStringsSep "\n" configLines}

    # Set up desktops
    for m in $(bspc query -M | sort -r); do
      bspc monitor $m -d ${desktopNamesStr}
    done

    # Extra lines
    ${localConf.extraLines}
  '';
in

with lib;

{
  options.programs.bspwmrc = {
    enable = options.mkEnableOption "bspwmrc";

    config = options.mkOption {
      type = types.attrsOf types.string;
      default = { };
    };

    desktopNames = options.mkOption {
      type = types.listOf types.str;
      default = [ "1" "2" "3" "4" ];
    };

    extraLines = options.mkOption {
      type = types.lines;
      default = "";
    };
  };

  config = lib.mkIf localConf.enable {
    environment.etc."bspwm/bspwmrc" = {
      text = bspwmrcContents;
      mode = "0555";
    };

    services.xserver.windowManager.bspwm.configFile = "/etc/bspwm/bspwmrc";
  };
}
