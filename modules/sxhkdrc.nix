{ lib, config, pkgs, ... }:

with lib;

let
  localConf = config.programs.sxhkdrc;

  sxhkdrcContents = builtins.concatStringsSep "\n\n" (
    attrsets.mapAttrsToList (key: command: key + "\n\t" + command) localConf.bindings
  );
in

{
  options.programs.sxhkdrc = {
    enable = options.mkEnableOption "sxhkdrc";

    bindings = options.mkOption {
      type = types.attrsOf types.string;
      default = { };
    };
  };

  config = lib.mkIf localConf.enable {
    environment.etc."sxhkd/sxhkdrc" = {
      text = sxhkdrcContents;
    };

    services.xserver.windowManager.bspwm.sxhkd.configFile = "/etc/sxhkd/sxhkdrc";
  };
}
