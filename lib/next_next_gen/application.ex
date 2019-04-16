defmodule NextNextGen.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      NextNextGen.Repo
      # Starts a worker by calling: NextNextGen.Worker.start_link(arg)
      # {NextNextGen.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NextNextGen.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
