{ ... }: {
  perSystem = { self', ... }: {
    apps = {
      tofu-validate = {
        type = "app";
        program = "${self'.packages.tofu-validate}/bin/tofu-validate";
      };

      tofu-plan = {
        type = "app";
        program = "${self'.packages.tofu-plan}/bin/tofu-plan";
      };

      tofu-apply = {
        type = "app";
        program = "${self'.packages.tofu-apply}/bin/tofu-apply";
      };
    };
  };
}
