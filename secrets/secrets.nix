let
  users = builtins.fromJSON (builtins.readFile ../users.json);
  publicKeys = builtins.foldl'
    (users: user: users // {
      "${user.username}" = user.publicKey;
    })
    { }
    users;
in
with publicKeys;
{
  "opentofu_passphrase.age".publicKeys = [ aciceri albertodvp ];
  "github_token.age".publicKeys = [ aciceri albertodvp ];
  "ambrogio_bot_password.age".publicKeys = [ aciceri albertodvp ];
}
