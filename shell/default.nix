{ inputs, ... }: {
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks-nix.flakeModule
  ];

  perSystem =
    { config
    , pkgs
    , lib
    , ...
    }: {
      treefmt.settings = {
        flakeFormatter = true;
        flakeCheck = true;
	global.exludes = [
          "*.png"
          "*.svg"
          "*.jpg"
	  "*.age"	  
	];
        programs = {
          nixpkgs-fmt.enable = true;
          typos.enable = true;
          terraform.enable = true;
          jsonfmt.enable = true;
        };
      };

      pre-commit = {
        check.enable = false; # treefmt already provices checks
        settings.hooks = {
          treefmt = {
            enable = true;
            package = config.treefmt.build.wrapper;
          };
        };
      };

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [ opentofu ragenix ];
        shellHook = ''
          ${config.pre-commit.installationScript}
          source ${lib.getExe config.agenix-shell.installationScript}
          tofu init
        '';
      };
    };
}
