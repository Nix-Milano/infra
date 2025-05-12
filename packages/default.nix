{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        tofu-validate = pkgs.writeShellApplication {
          name = "tofu-validate";
          runtimeInputs = [ pkgs.opentofu ];
          text = ''
            set -e
            echo "Running tofu validate..."
            tofu validate
          '';
        };

        tofu-plan = pkgs.writeShellApplication {
          name = "tofu-plan";
          runtimeInputs = [ pkgs.opentofu ];
          text = ''
            set -e
            echo "Running tofu plan..."
            tofu plan
          '';
        };

        tofu-apply = pkgs.writeShellApplication {
          name = "tofu-apply";
          runtimeInputs = [ pkgs.opentofu ];
          text = ''
            set -e
            echo "Running tofu apply..."
            tofu apply -auto-approve
          '';
        };
      };
    };
}
