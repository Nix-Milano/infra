{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    agenix-shell.url = "github:aciceri/agenix-shell";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        systems = lib.systems.flakeExposed;
        flake = {
          githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
            checks = inputs.nixpkgs.lib.getAttrs [ "x86_64-linux" "x86_64-darwin" ] inputs.self.checks;
          };
        };
        imports = [
          ./checks
          ./packages
          ./secrets
          ./shell
        ];
      }
    );
}
