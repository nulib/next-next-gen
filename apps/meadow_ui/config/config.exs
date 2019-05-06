# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :meadow_ui, MeadowUiWeb.Endpoint,
  ecto_repos: [Meadow.Data.Repo],
  generators: [context_app: :meadow_data],
  url: [host: "localhost"],
  secret_key_base: "XFNRNprpVP6+GdVa7yth7iX5kqD9Btk+D0uyFbNTKdPX3vO9gybs/uWsfzPUps2X",
  render_errors: [view: MeadowUiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MeadowUi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
