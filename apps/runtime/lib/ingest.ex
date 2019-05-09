defmodule Meadow.Runtime.Ingest do
  @start_apps [
    :crypto,
    :httpoison,
    :ssl,
    :meadow_data
  ]

  def ingest(argv) do
    start_services()
    Meadow.Ingest.Storage.ensure_bucket_exists()
    argv
    |> Stream.each(&Meadow.Ingest.ingest_manifest(&1))
    |> Stream.run()
    stop_services()
  end


  defp start_services do
    IO.puts("Starting dependencies..")
    # Start apps necessary for ingest
    Enum.each(@start_apps, &Application.ensure_all_started/1)
  end

  defp stop_services do
    IO.puts("Success!")
    :init.stop()
  end
end
