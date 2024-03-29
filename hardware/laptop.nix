{ config, lib, modulesPath, nixos-hardware, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (nixos-hardware + "/dell/xps/13-9370/default.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/8bd3e33b-68f0-47e5-ab8c-43fbc2a6d64b";
    fsType = "xfs";
  };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/f406f2ab-1758-4ed0-9e7c-d91bde543c06";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F11D-8867";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/dac38c23-783a-4618-b4d3-d43422df3162"; }
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
