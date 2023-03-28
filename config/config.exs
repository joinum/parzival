# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :parzival,
  ecto_repos: [Parzival.Repo]

config :flop,
  default_limit: 9,
  repo: Parzival.Repo

# Configures the endpoint
config :parzival, ParzivalWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ParzivalWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Parzival.PubSub,
  live_view: [signing_salt: "h9dkyv4j"]

config :waffle,
  storage: Waffle.Storage.Local,
  storage_dir_prefix: "priv",
  asset_host: {:system, "ASSET_HOST"}

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :parzival, Parzival.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tailwind,
  version: "3.0.12",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# configure event dates 
config :parzival,
  event: %{
    first_day_start: ~N[2022-06-28 00:00:00],
    first_day_end: ~N[2022-06-28 23:59:59],
    second_day_start: ~N[2022-06-29 00:00:00],
    second_day_end: ~N[2022-06-29 23:59:59],
    third_day_start: ~N[2022-06-30 00:00:00],
    third_day_end: ~N[2022-06-30 23:59:59]
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
