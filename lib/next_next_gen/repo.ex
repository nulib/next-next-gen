defmodule NextNextGen.Repo do
  use Ecto.Repo,
    otp_app: :next_next_gen,
    adapter: Ecto.Adapters.Postgres
end
