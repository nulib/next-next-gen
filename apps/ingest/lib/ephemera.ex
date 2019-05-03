defmodule Meadow.Ingest.Ephemera do
  @moduledoc """
  Temporary data storage
  """

  @table_name :ephemera

  @doc """
  Initialize ephemeral storage
  """
  def init(), do: table()

  @doc """
  Get all resources, keys, and values
  """
  def all(), do: :ets.match(table(), {:"$1", :"$2", :"$3"})

  @doc """
  Store a value
  """
  def store(resource, key, value), do: :ets.insert(table(), {resource, key, value})

  @doc """
  Fetch a value
  """
  def fetch(resource, key) do
    case :ets.match(table(), {resource, key, :"$3"}) do
      [] -> nil
      [[val]] -> val
    end
  end

  @doc """
  Delete a value
  """
  def delete(resource, key), do: :ets.match_delete(table(), {resource, key, :_})

  @doc """
  Fetch the value of the given resource/key, perform a function, and then
  delete the value from the store
  """
  def take(resource, key, fun) do
    fetch(resource, key) |> fun.()
    delete(resource, key)
  end

  defp table() do
    case :ets.info(@table_name) do
      :undefined -> :ets.new(@table_name, [:set, :public, :named_table])
      info -> info[:id]
    end
  end
end
