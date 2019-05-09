use Mix.Config

config :meadow_data, Meadow.Data.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: 10,
  log: false

config :meadow_data, Meadow.Data.Ephemera,
  host: System.get_env("REDIS_HOST") || "localhost",
  port: String.to_integer(System.get_env("REDIS_PORT") || "6379")
