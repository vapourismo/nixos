{ lib, config, pkgs, ... }:

with lib;

let
  localConf = config.programs.sxhkdrc;

  contents = builtins.concatStringsSep "\n\n" (
    attrsets.mapAttrsToList (key: command: key + "\n\t" + command) localConf.bindings
  );

  sxhkdrc = pkgs.writeScript "sxhkdrc" contents;
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
    services.xserver.windowManager.bspwm.sxhkd.configFile = sxhkdrc;
  };
}
