use Mix.Config

# Configures the endpoint
config :meadow_ui, MeadowUiWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "localhost", port: {:system, "PORT"}], # This is critical for ensuring web-sockets properly authorize.
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  root: ".",
  version: Application.spec(:meadow_ui, :vsn),
  ecto_repos: [Meadow.Data.Repo],
  generators: [context_app: :meadow_data],
  secret_key_base: "XFNRNprpVP6+GdVa7yth7iX5kqD9Btk+D0uyFbNTKdPX3vO9gybs/uWsfzPUps2X",
  render_errors: [view: MeadowUiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MeadowUi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :meadow_data, Meadow.Data.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: 10,
  log: false

config :meadow_data, Meadow.Data.Ephemera,
  host: System.get_env("REDIS_HOST") || "localhost",
  port: String.to_integer(System.get_env("REDIS_PORT") || "6379")

config :ingest, storage_bucket: System.get_env("MEADOW_STORAGE_BUCKET")

aws_key = fn key ->
  profile = System.get_env("AWS_PROFILE") || System.get_env("AWS_DEFAULT_PROFILE")
  [ {:system, key}, {:awscli, profile, 30}, :instance_role ]
end

shared_config = [
  access_key_id: aws_key.("AWS_ACCESS_KEY_ID"),
  secret_access_key: aws_key.("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION") || System.get_env("AWS_DEFAULT_REGION")
]

case System.get_env("AWS_ENDPOINT") do
  nil ->
    config :ex_aws, shared_config

  url ->
    with %URI{scheme: scheme, host: host, port: port} <- URI.parse(url) do
      config :ex_aws,
             :s3,
             shared_config ++
               [host: host, port: port, scheme: scheme]
    end
end
