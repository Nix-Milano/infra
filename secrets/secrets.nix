let
  users = builtins.fromJSON (builtins.readFile ../users.json);
  publicKeys =
    builtins.foldl'
      (users: user:
        users
        // {
          "${user.username}" = user.publicKey;
        })
      { }
      users;
in
with publicKeys; {
  "opentofu_passphrase.age".publicKeys = [ aciceri albertodvp ambrogio-bot ];
  "github_token.age".publicKeys = [ aciceri albertodvp ambrogio-bot ];
  "ambrogio_bot_password.age".publicKeys = [ aciceri albertodvp ];
  "ambrogio_bot_ssh_private_key.age".publicKeys = [ aciceri albertodvp ];
}
