defmodule Meadow.Ingest.Manifest do
  @moduledoc """
  Parses a CSV file into an ingestible manifest.
  """

  alias NimbleCSV.RFC4180, as: CSV

  defstruct source: nil, email: nil, entries: nil
  @type t :: %__MODULE__{source: String.t(), email: String.t(), entries: [Map.t()]}

  @doc "Read a CSV manifest from a given location and parse it into a Manifest struct"
  @spec from_location(String.t()) :: {:ok | :error, t}
  def from_location(location) do
    try do
      location
      |> URI.parse()
      |> read_from_uri
      |> from_string(location)
    rescue
      e in RuntimeError -> {:error, e.message}
    end
  end

  @doc "Parse a string of CSV manifest data into a Manifest struct"
  @spec from_string(String.t(), String.t() | :string) :: {:ok | :error, t}
  def from_string(content, source \\ :string) do
    [email_row | [header_row | rows]] = content |> CSV.parse_string(skip_headers: false)
    headers = header_row |> Enum.map(&String.to_atom(&1))

    {:ok,
     %__MODULE__{
       source: source,
       email: List.first(email_row),
       entries: Enum.map(rows, &zip(headers, &1))
     }}
  end

  defp read_from_uri(%URI{scheme: "s3", host: bucket, path: key}) do
    bucket
    |> ExAws.S3.get_object(String.trim(key, "/"))
    |> ExAws.request!()
    |> (fn response -> response.body end).()
  end

  defp read_from_uri(%URI{scheme: scheme, path: path}) when scheme in ["file", nil] do
    path
    |> File.read!()
  end

  defp read_from_uri(uri = %URI{}) do
    case HTTPoison.get(URI.to_string(uri)) do
      {:ok, %HTTPoison.Response{status_code: x, body: body}} when x in 200..299 ->
        body

      {_, _} ->
        raise "Unable to retrieve #{uri}"
    end
  end

  defp take_subfield_headers(subfield, headers, fields) do
    take_subfield_headers(subfield, [], [], headers, fields)
  end

  defp take_subfield_headers(_subfield, file_headers, file_fields, [], fields) do
    [file_headers, file_fields, [], fields]
  end

  defp take_subfield_headers(subfield, file_headers, file_fields, [header | headers], [
         field | fields
       ]) do
    case {header, field} do
      {:file, _} ->
        [file_headers, file_fields, [header | headers], [field | fields]]

      {_, ""} ->
        [file_headers, file_fields, headers, fields]

      {_, _} ->
        take_subfield_headers(
          subfield,
          file_headers ++ [header],
          file_fields ++ [field],
          headers,
          fields
        )
    end
  end

  defp zip(headers, fields), do: zip(%{}, headers, fields)
  defp zip(map, [], _), do: map

  defp zip(map, [:file | headers], [field | fields]) do
    [file_headers, file_fields, headers, fields] = take_subfield_headers(:file, headers, fields)
    file_map = zip(%{file: field}, file_headers, file_fields)

    case field do
      "" -> map
      _ -> Map.update(map, :files, [file_map], &(&1 ++ [file_map]))
    end
    |> zip(headers, fields)
  end

  defp zip(map, [header | headers], [field | fields]) do
    case {String.trim(to_string(header)), String.trim(to_string(field))} do
      {"", _} -> map
      {_, ""} -> map
      {_, _} -> Map.update(map, header, [field], &(&1 ++ [field]))
    end
    |> zip(headers, fields)
  end
end
