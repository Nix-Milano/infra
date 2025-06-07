{ ... }:
{
  perSystem =
    { pkgs, lib, config, ... }:
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

        tofu-apply-in-workflow = pkgs.writeShellScriptBin "tofu-apply-in-workflow"
        ''
          source "${lib.getExe config.agenix-shell.installationScript}"
          ${lib.getExe pkgs.opentofu} apply --auto-approve
        '';
      };
    };
}
