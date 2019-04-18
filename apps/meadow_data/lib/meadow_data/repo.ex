defmodule Meadow.Data.Repo do
  use Ecto.Repo,
    otp_app: :meadow_data,
    adapter: Ecto.Adapters.Postgres
end
