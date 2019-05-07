defmodule Meadow.Data.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      Meadow.Data.Repo,
      {Redix, Application.get_env(:meadow_data, Meadow.Data.Ephemera) ++ [name: :ephemera]}
      # Starts a worker by calling: Meadow.Data.Worker.start_link(arg)
      # {Meadow.Data.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Meadow.Data.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
