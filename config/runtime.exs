import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# Start the phoenix server if environment is set and running in a release
if System.get_env("PHX_SERVER") do
  config :parzival, ParzivalWeb.Endpoint, server: true
end

if config_env() in [:dev, :test] do
  import Dotenvy
  source([".env", ".env.#{config_env()}", ".env.#{config_env()}.local"])

  config :parzival, Parzival.Repo,
    username: env!("DB_USERNAME", :string, "postgres"),
    password: env!("DB_PASSWORD", :string, "postgres"),
    # The MIX_TEST_PARTITION environment variable can be used
    # to provide built-in test partitioning in CI environment.
    database:
      env!("DB_NAME", :string, "join_#{config_env()}#{System.get_env("MIX_TEST_PARTITION")}"),
    hostname: env!("DB_HOST", :string, "localhost"),
    port: env!("DB_PORT", :integer, 5432)
end

if config_env() in [:prod, :stg] do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  %URI{host: database_host} = URI.parse(database_url)

  # Location of root certificates to verify database SSL connection.
  database_ca_cert_filepath =
    System.get_env("DATABASE_CA_CERT_FILEPATH") || "/etc/ssl/certs/ca-certificates.crt"

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  config :parzival, Parzival.Repo,
    url: database_url,
    # Our production/staging database requires SSL to be enabled to connect. This enables verifying the Postgres server has a valid certificate.
    ssl: true,
    ssl_opts: [
      verify: :verify_peer,
      cacertfile: database_ca_cert_filepath,
      server_name_indication: to_charlist(database_host),
      customize_hostname_check: [
        # Our hosting provider uses a wildcard certificate. By default, Erlang does not support wildcard certificates. This function supports validating wildcard hosts.
        match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
      ]
    ],
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

  host = System.get_env("PHX_HOST") || "join.di.uminho.pt"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :parzival, ParzivalWeb.Endpoint,
    url: [host: host, port: 443],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  aws_smtp_username =
    System.get_env("AWS_SMTP_USERNAME") ||
      raise """
      environment variable AWS_SMTP_USERNAME is missing
      """

  aws_smtp_password =
    System.get_env("AWS_SMTP_PASSWORD") ||
      raise """
      environment variable AWS_SMTP_PASSWORD is missing
      """

  config :parzival, Parzival.Mailer,
    adapter: Swoosh.Adapters.SMTP,
    relay: "email-smtp.eu-west-2.amazonaws.com",
    username: aws_smtp_username,
    password: aws_smtp_password,
    ssl: false,
    tls: :always,
    auth: :always,
    port: 587,
    retries: 2,
    no_mx_lookups: false

  # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  #     config :parzival, ParzivalWeb.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :parzival, Parzival.Mailer,
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
end
