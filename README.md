# Toolbox

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex.bat -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

$env:HEX_UNSAFE_HTTPS = 1
mix deps.get 


See https://hexdocs.pm/mix/Mix.Tasks.Release.html for more information about Elixir releases.

Here are some useful release commands you can run in any release environment:

    # To build a release
    mix release

Release created at _build/prod/rel/toolbox!

    # To start your system
    _build/prod/rel/toolbox/bin/toolbox start

Once the release is running:

    # To connect to it remotely
    _build/prod/rel/toolbox/bin/toolbox remote

    # To stop it gracefully (you may also send SIGINT/SIGTERM)
    _build/prod/rel/toolbox/bin/toolbox stop

To list all commands:

    _build/prod/rel/toolbox/bin/toolbox
