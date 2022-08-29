{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
    nixos-hardware.url = github:NixOS/nixos-hardware;
  };

  outputs = { nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      "ole-desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/desktop.nix ];
      };

      "ole-laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/laptop.nix ];
        specialArgs = inputs;
      };
    };
  };
}
