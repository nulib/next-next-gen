defmodule NextNextGen.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias NextNextGen.Repo

      import Ecto
      import Ecto.Query
      import NextNextGen.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(NextNextGen.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(NextNextGen.Repo, {:shared, self()})
    end

    :ok
  end
end
