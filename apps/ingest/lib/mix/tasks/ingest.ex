defmodule Mix.Tasks.Meadow.Ingest do
  use Mix.Task

  @impl Mix.Task
  @shortdoc "Ingest a manifest"
  def run(args) do
    Mix.EctoSQL.ensure_started(Meadow.Data.Repo, [])
    {:ok, _started} = Application.ensure_all_started(:httpoison)

    Meadow.Ingest.Storage.ensure_bucket_exists()
    Meadow.Ingest.ingest_manifest(List.first(args))
  end
end
