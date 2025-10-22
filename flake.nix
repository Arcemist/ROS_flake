{
  description = "A ROS Development Enviroment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/master";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";  # IMPORTANT!!!
  };

  outputs = { self, nixpkgs, flake-utils, nix-ros-overlay }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nix-ros-overlay.overlays.default ];
      };
    in {
      devShells.default = with pkgs; mkShell {
        buildInputs = [
	    (with pkgs.rosPackages.kilted; buildEnv {
	      paths = [
		ros-core
	      ];
	    })
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
