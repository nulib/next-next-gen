defmodule Meadow.Data.Ephemera do
  @moduledoc """
  Temporary data storage
  """

  @prefix "meadow"
  @table_name :ephemera

  @doc """
  Initialize ephemeral storage
  """
  def init(), do: table()

  @doc """
  Get all resources, keys, and values
  """
  def all() do
    Redix.command!(@table_name, ["SCAN", "0", "MATCH", key_for("*")])
    |> List.last()
    |> Enum.reduce(%{}, fn key, acc ->
      Map.put(
        acc,
        String.replace_leading(key, @prefix <> ":", ""),
        all(key)
      )
    end)
  end

  @doc """
  Get all keys and values for a specific resource
  """
  def all(resource) do
    Redix.command!(@table_name, ["HSCAN", resource, "0"])
    |> List.last()
    |> Enum.chunk_every(2)
    |> Enum.map(fn [a, b] -> {a, b} end)
    |> Map.new()
  end

  @doc """
  Store a value
  """
  def store(resource, key, value),
    do: Redix.command!(@table_name, ["HSET", key_for(resource), key, value])

  @doc """
  Fetch a value
  """
  def fetch(resource, key),
    do: Redix.command!(@table_name, ["HGET", key_for(resource), key])

  @doc """
  Delete a value
  """
  def delete(resource, key),
    do: Redix.command!(@table_name, ["HDEL", key_for(resource), key])

  @doc """
  Fetch the value of the given resource/key, perform a function, and then
  delete the value from the store
  """
  def take(resource, key, fun) do
    fetch(resource, key) |> fun.()
    delete(resource, key)
  end

  defp key_for(str), do: Enum.join([@prefix, str], ":")

  defp table(), do: Redix.command!(@table_name, ["PING"])
end
