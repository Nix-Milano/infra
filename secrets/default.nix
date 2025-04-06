{ inputs, ... }: {
  imports = [
    inputs.agenix-shell.flakeModules.default
  ];

  agenix-shell = {
    secrets = {
      TF_VAR_github_token.file = ./github_token.age;
      TF_VAR_opentofu_passphrase.file = ./opentofu_passphrase.age;
    };
  };
}
