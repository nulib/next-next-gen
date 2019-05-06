use Mix.Config

config :meadow_data, Meadow.Data.Repo,
  username: "docker",
  password: "d0ck3r",
  database: "meadow_dev",
  hostname: "localhost",
  port: 5433,
  pool_size: 10,
  log: false

config :meadow_data, Meadow.Data.Ephemera,
  host: "localhost",
  port: 6380
