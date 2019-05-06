defmodule Meadow.Ingest.Storage do
  @moduledoc """
  Functions related to FileSet binary storage
  """
  alias Meadow.Data.Ephemera

  @source_key "source_location"

  @doc """
  Make sure the target storage bucket exists
  """
  def ensure_bucket_exists(bucket \\ storage_bucket()) do
    case bucket do
      :undefined ->
        {:error, "Storage bucket not configured"}

      bucket ->
        case ExAws.S3.head_bucket(bucket) |> ExAws.request() do
          {:error, {:http_error, 404, _}} ->
            ExAws.S3.put_bucket(bucket, "us-east-1")
            |> ExAws.request!()

            {:ok, :created}

          {:ok, _} ->
            {:ok, :exists}

          other ->
            other
        end
    end
  end

  @doc """
  Determine the proper storage location for a given ID
  """
  def location_for(id), do: %URI{scheme: "s3", host: storage_bucket(), path: pairtree(id)}

  @doc """
  Store the import location of a file so that it can be
  copied to its at-rest location later
  """
  def store_source_location(file_id, location),
    do: Ephemera.store(file_id, @source_key, location)

  @doc """
  Move a file from its source location to its at-rest location
  """
  def move_to_storage(file_id) do
    Ephemera.take(file_id, @source_key, fn source_location ->
      dest_location = location_for(file_id)
      upload_file(URI.parse(source_location), dest_location)
    end)
  end

  defp storage_bucket(), do: Application.get_env(:ingest, :storage_bucket)

  defp pairtree(str), do: "/" <> Path.join(for(<<pair::binary-2 <- str>>, do: pair) ++ [str])

  defp upload_file(
         %URI{scheme: "s3", host: src_bucket, path: src_key},
         %URI{scheme: "s3", host: dest_bucket, path: dest_key}
       ) do
    ExAws.S3.put_object_copy(dest_bucket, String.trim(dest_key, "/"), src_bucket, src_key)
    |> ExAws.request!()
  end

  defp upload_file(
         %URI{scheme: src_scheme, path: src_path},
         %URI{scheme: "s3", host: dest_bucket, path: dest_key}
       )
       when src_scheme in ["file", nil] do
    src_path
    |> ExAws.S3.Upload.stream_file()
    |> ExAws.S3.upload(dest_bucket, String.trim(dest_key, "/"))
    |> ExAws.request!()
  end

  defp upload_file(
         %URI{} = source,
         %URI{scheme: "s3", host: dest_bucket, path: dest_key}
       ) do
    response = URI.to_string(source) |> HTTPoison.get!()

    ExAws.S3.put_object(dest_bucket, String.trim(dest_key, "/"), response.body)
    |> ExAws.request!()
  end
end
