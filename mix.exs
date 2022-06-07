defmodule Parzival.MixProject do
  use Mix.Project

  @app :parzival
  @version "1.0.0-beta"
  @name "JOIN"
  @description "Jornadas de Informática"

  def project do
    [
      app: @app,
      name: @name,
      description: @description,
      version: @version,
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Parzival.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # web
      {:phoenix, "~> 1.6.6"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_view, "~> 0.17.5"},

      # database
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:ecto_psql_extras, "~> 0.6"},

      # uploads
      {:waffle, "~> 1.1"},
      {:waffle_ecto, "~> 0.0"},

      # pagination
      {:flop, "~> 0.15.0"},

      # icons
      {:icons, "~> 0.7.1"},

      # QRCode
      {:qrcode_ex, "~> 0.1.0"},

      # i18n
      {:gettext, "~> 0.18"},

      # security
      {:bcrypt_elixir, "~> 3.0"},

      # mailer
      {:swoosh, "~> 1.3"},

      # utilities
      {:pdf_generator, "~> 0.6.2"},
      {:earmark, "~> 1.4.0"},
      {:timex, "~> 3.0"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},

      # monitoring
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:phoenix_live_dashboard, "~> 0.6"},

      # development
      {:dotenvy, "~> 0.6.0"},
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},

      # testing
      {:faker, "~> 0.17", only: [:dev, :test]},
      {:floki, ">= 0.30.0", only: :test},

      # tools
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd --cd assets npm install"],
      format: ["cmd ./assets/node_modules/rustywind/bin/rustywind --write .", "format"],
      "ecto.seed": ["run priv/repo/seeds.exs"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "ecto.seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
