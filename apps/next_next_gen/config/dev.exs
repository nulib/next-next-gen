use Mix.Config

config :next_next_gen, NextNextGen.Repo,
  username: "docker",
  password: "d0ck3r",
  database: "next_next_gen_dev",
  hostname: "localhost",
  port: 5433,
  pool_size: 10
