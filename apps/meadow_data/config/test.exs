use Mix.Config

config :meadow_data, Meadow.Data.Repo,
  username: "docker",
  password: "d0ck3r",
  database: "meadow_test",
  hostname: "localhost",
  port: if(System.get_env("CI"), do: 5432, else: 5434),
  pool: Ecto.Adapters.SQL.Sandbox
