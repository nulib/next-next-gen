defmodule Meadow.Ingest do
  @moduledoc """
  Ingest manifests, create Images and FileSets
  """

  alias Meadow.Ingest.{Manifest, Storage}
  alias Meadow.Data.{Ephemera, FileSet, Image, Repo}

  @doc """
  Ingest a manifest full of Image objects
  """
  def ingest_manifest(%Manifest{} = manifest) do
    Storage.ensure_bucket_exists()
    Ephemera.init()

    manifest.entries
    |> Task.async_stream(&ingest_object(&1, URI.parse(manifest.source)))
    |> Enum.count()
  end

  def ingest_manifest(manifest) do
    {:ok, result} = Manifest.from_location(manifest)
    ingest_manifest(result)
  end

  @doc """
  Ingest an object
  """
  def ingest_object(attributes, source) do
    IO.puts("#{attributes.title} [begin]")

    attributes
    |> create_object
    |> attach_files(attributes, source)
    |> upload_files

    IO.puts("#{attributes.title} [end]")
  end

  defp create_object(attributes) do
    %Image{}
    |> Image.changeset(singularize(attributes, [:title, :accession_number, :ark]))
    |> Repo.insert!()
  end

  defp attach_files(parent, attributes, source) do
    attributes.files
    |> Enum.map(&attach_file(parent, &1.file, source))
  end

  defp attach_file(parent, file, source) do
    file_set = %FileSet{id: Ecto.ULID.generate()}

    file_uri = URI.parse(file)

    source_location =
      case file_uri.scheme do
        nil -> %URI{source | path: Path.expand(file, Path.dirname(source.path))}
        _ -> file_uri
      end

    dest_location = Storage.location_for(file_set.id)

    Storage.store_source_location(file_set.id, URI.to_string(source_location))

    file_set
    |> FileSet.changeset(%{
      image_id: parent.id,
      original_filename: Path.basename(file),
      location: URI.to_string(dest_location)
    })
    |> Repo.insert!()
  end

  defp upload_files(file_sets) do
    file_sets
    |> Enum.each(&upload_file(&1))
  end

  defp upload_file(file_set), do: Storage.move_to_storage(file_set.id)

  defp singularize(attributes, [key | []]) do
    attributes
    |> singularize(key)
  end

  defp singularize(attributes, [key | keys]) do
    attributes
    |> singularize(keys)
    |> singularize(key)
  end

  defp singularize(attributes, key) do
    attributes
    |> Map.put(
      key,
      case attributes[key] do
        val when is_list(val) -> List.first(val)
        val -> val
      end
    )
  end
end
