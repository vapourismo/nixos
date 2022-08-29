{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9121a1a2-ec0f-4a5b-9cb6-cb3d7827ac91";
    fsType = "xfs";
  };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/ca92e301-22dc-4371-8217-cc69edb3a097";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1646-C9DB";
    fsType = "vfat";
  };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
