{ lib, config, pkgs, ... }:

let
  localConf = config.programs.dmenu-launcher;

  dmenu-launcher = pkgs.stdenv.mkDerivation {
    name = "dmenu-launcher";

    launcherScript = pkgs.writeText "dmenu-launcher" ''
      #!/bin/sh

      launchDmenu() {
        dmenu_path | dmenu -i -b -sb '${localConf.selectedBackground}' -sf '${localConf.selectedForeground}' -nb '${localConf.background}' -nf '${localConf.foreground}' -fn '${localConf.font}' -l ${builtins.toString localConf.lines}
      }

      current_monitor=$(bspc query -M -m focused)
      prev_padding=$(bspc config -m $current_monitor bottom_padding)
      bspc config -m $current_monitor bottom_padding ${builtins.toString localConf.bottomPadding}

      command="$(launchDmenu)"

      bspc config -m $current_monitor bottom_padding $prev_padding

      $command
    '';

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cp $launcherScript $out/bin/dmenu-launcher
      chmod +x $out/bin/dmenu-launcher
    '';
  };
in

with lib;

{
  options.programs.dmenu-launcher = {
    enable = options.mkEnableOption "dmenu-launcher";

    selectedBackground = options.mkOption {
      type = types.str;
      default = "#96373C";
    };

    selectedForeground = options.mkOption {
      type = types.str;
      default = "#d2d2d2";
    };

    background = options.mkOption {
      type = types.str;
      default = "#111111";
    };

    foreground = options.mkOption {
      type = types.str;
      default = "#d2d2d2";
    };

    font = options.mkOption {
      type = types.str;
      default = "iosevka ss02-9";
    };

    lines = options.mkOption {
      type = types.int;
      default = 5;
    };

    bottomPadding = options.mkOption {
      type = types.int;
      default = 110;
    };

    package = options.mkOption {
      type = types.package;
      default = dmenu-launcher;
    };
  };

  config = lib.mkIf localConf.enable {
    environment.systemPackages = [ localConf.package pkgs.dmenu pkgs.bspwm ];
  };
}
