defmodule Mix.Tasks.Meadow.CreateManifest do
  use Mix.Task
  alias NimbleCSV.RFC4180, as: CSV

  @keywords ~w(unknown obtainable pale reflective minor phobic spotty exchange foot girl obedient breath heap loud club)

  @impl Mix.Task
  @shortdoc "Generate a manifest of random images from Flickr"
  def run([count | [filename | [email | []]]]) do
    {:ok, _started} = Application.ensure_all_started(:httpoison)

    [
      [email, nil, nil, nil, nil, nil]
      | [
          ~w(accession_number title description keyword keyword keyword file file file file file)
          | build_manifest(String.to_integer(count), Path.join(Path.dirname(filename), "files"))
        ]
    ]
    |> CSV.dump_to_stream()
    |> Stream.into(File.stream!(filename))
    |> Stream.run()
  end

  defp build_manifest(count, file_location) do
    Range.new(1, count)
    |> Enum.map(fn row ->
      [
        "acc.#{row}",
        "Object ##{row}",
        "Description of Object ##{row}"
      ] ++ keywords() ++ files(file_location)
    end)
  end

  defp keywords() do
    random_padded_list(@keywords, 0, 3)
  end

  defp files(location) do
    File.ls!(location)
    |> random_padded_list(1, 5)
    |> Enum.map(fn
      nil -> nil
      file -> Path.join(Path.basename(location), file)
    end)
  end

  defp random_padded_list(source, min, count) do
    taken =
      source
      |> Enum.shuffle()
      |> Enum.take(:rand.uniform(count + 1) - 1 + min)

    (taken ++ Enum.take(Stream.cycle([nil]), count))
    |> Enum.take(count)
  end
end
