defmodule Mix.Tasks.Meadow.Ingest do
  use Mix.Task

  @impl Mix.Task
  @shortdoc "Ingest a manifest"
  def run(args) do
    {:ok, _started} = Application.ensure_all_started(:httpoison)
    {:ok, _started} = Application.ensure_all_started(:meadow_data)

    Meadow.Ingest.Storage.ensure_bucket_exists()
    Meadow.Ingest.ingest_manifest(List.first(args))
  end
end
