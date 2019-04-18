use Mix.Config

config :next_next_gen, NextNextGen.Repo,
  username: "docker",
  password: "d0ck3r",
  database: "next_next_gen_test",
  hostname: "localhost",
  port: if(System.get_env("CI"), do: 5432, else: 5434),
  pool: Ecto.Adapters.SQL.Sandbox
