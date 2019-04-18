defmodule Meadow.Data.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Meadow.Data.Repo

      import Ecto
      import Ecto.Query
      import Meadow.Data.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Meadow.Data.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Meadow.Data.Repo, {:shared, self()})
    end

    :ok
  end
end
