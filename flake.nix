{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
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
      };
    };
  };
}
