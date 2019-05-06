defmodule Mix.Tasks.Meadow.CreateManifest do
  use Mix.Task
  alias NimbleCSV.RFC4180, as: CSV

  @impl Mix.Task
  @shortdoc "Generate a manifest of random images from Flickr"
  def run([count | [filename | []]]) do
    Faker.start()
    {:ok, _started} = Application.ensure_all_started(:httpoison)

    [
      [Faker.Internet.email(), nil, nil, nil, nil, nil]
      | [
          ~w(accession_number title description keyword keyword keyword file file file file file)
          | build_manifest(String.to_integer(count), Path.join(Path.dirname(filename), "files"))
        ]
    ]
    |> CSV.dump_to_stream()
    |> Stream.into(File.stream!(filename))
    |> Stream.run()
  end

  defp new_accession_number(list) do
    accession_no = Faker.Nato.format("?-#-?-?-?")

    case Enum.member?(list, accession_no) do
      true -> new_accession_number(list)
      false -> accession_no
    end
  end

  defp build_manifest(count, file_location) do
    powers = Enum.map(1..20, fn _ -> Faker.Superhero.power() end)

    accession_list =
      Enum.reduce(Range.new(1, count), [], fn _, acc ->
        acc ++ [new_accession_number(acc)]
      end)

    Range.new(1, count)
    |> Enum.map(fn index ->
      [
        Enum.at(accession_list, index),
        Faker.Lorem.sentence(),
        Faker.Lorem.paragraph()
      ] ++ keywords(powers) ++ files(file_location)
    end)
  end

  defp keywords(list) do
    random_padded_list(list, 0, 3)
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
