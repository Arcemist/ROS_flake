{
  description = "A Python Development Enviroment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      # Unnecesary for the moment:
      # overlays = [ ];
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      devShells.default = with pkgs; mkShell {
        buildInputs = [
	  (pkgs.python3.withPackages (py-pkgs: with py-pkgs; [
              # Additional python packages go here
	      python-lsp-server
	  ]))
	];

        # For convinience
	# Need fish in normal user enviroment
	# The "exec" makes it so it does not need to be closed 2 times
	shellHook = ''
          exec fish
	'';
      };

      # nix develop .#nombre
      # Makes a dev enviroment that includes what you put here,
      # in addition to what is in the default option.
      #devShells.nombre = pkgs.mkShell {
      #  buildInputs = [
      #    pkgs.lsd
      #  ];
      #};
    }
  );
}
