import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/toolbox start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if System.get_env("PHX_SERVER") do
  config :toolbox, ToolboxWeb.Endpoint, server: true
end

if config_env() == :prod do
  efront_database_url =
    System.get_env("EFRONT_DATABASE_URL") ||
      raise """
      environment variable EFRONT_DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  chrono_database_url =
    System.get_env("CHRONO_DATABASE_URL") ||
      raise """
      environment variable CHRONO_DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  config :toolbox, Toolbox.EfrontRepo,
    # ssl: true,
    url: efront_database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  config :toolbox, Toolbox.Repo,
    # ssl: true,
    url: chrono_database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "localhost"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :toolbox, ToolboxWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    # http: [
    #   # Enable IPv6 and bind on all interfaces.
    #   # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
    #   # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
    #   # for details about using IPv6 vs IPv4 and loopback vs public addresses.
    #   # ip: {0, 0, 0, 0, 0, 0, 0, 0},
    #   # utilisation d'une PUBLIC IP ADDRESS
    #   ip: {0, 0, 0, 0},
    #   port: port
    # ],
    https: [
      ip: {0, 0, 0, 0},
      port: port,
      cipher_suite: :strong,
      certfile: "priv/cert/selfsigned.pem",
      keyfile: "priv/cert/selfsigned_key.pem"
    ],
    secret_key_base: secret_key_base,
    check_origin: [
      "https://toolbox",
      "https://localhost"
    ]

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :toolbox, Toolbox.Mailer,
  #       adapter: Swoosh.Adapters.Mailgun,
  #       api_key: System.get_env("MAILGUN_API_KEY"),
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.

  # Configuration de l'authentification AzureAd

  config :ueberauth, Ueberauth.Strategy.Microsoft.OAuth,
    tenant_id: "1839f17e-240c-44a4-8d24-b717d8b4bcdf",
    client_id: "3dc47379-90de-48d4-9853-0780c0a6a314",
    client_secret: "djUycT7K_2_Yb4.9yIM62T5-k5g9_r-O_t"
end
