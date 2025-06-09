{ ... }: {
  perSystem =
    { pkgs
    , lib
    , config
    , ...
    }: {
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

        tofu-apply-in-workflow = pkgs.writeShellApplication {
          name = "tofu-apply-in-workflow";
          runtimeInputs = with pkgs; [ opentofu git ];
          text = ''
            set -e
            source "${lib.getExe config.agenix-shell.installationScript}"
            tofu init
            tofu apply --auto-approve
            if ! git diff --cached --exit-code "terraform.tfstate"; then
              echo "Changes detected in terraform.tfstate, committing..."
              git add terraform.tfstate
              git config --global gpg.format ssh
              git config --global user.signingkey ~/.ssh/id_ed25519.pub
              git config --global commit.gpgsign true
              git commit -m "Automatic terraform state update"
              git push origin master
            fi
          '';
        };
      };
    };
}
