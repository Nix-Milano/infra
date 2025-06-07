{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    checks = {
      tofu-validate =
        pkgs.runCommand "tofu-validate"
          {
            nativeBuildInputs = [ pkgs.opentofu ];
          } ''
          set -e
          tofu validate
          mkdir -p $out
          echo "Validation OK" > $out/success
        '';
    };
  };
}
