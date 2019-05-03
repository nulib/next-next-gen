defmodule MeadowIngestEphemeraTest do
  use ExUnit.Case
  doctest Meadow.Ingest.Ephemera

  describe "ephemeral storage" do
    alias Meadow.Ingest.Ephemera

    @resource "01D9Z7C1JYCPSP4P8V0P5AG958"

    setup do
      Ephemera.store(@resource, "preexisting_key", "preexisting_value")
      []
    end

    test "initialization" do
      assert Ephemera.init()
    end

    test "unknown resource/key returns nil" do
      assert Ephemera.fetch(@resource, "unknown") == nil
    end

    test "fetching existing key returns value and leaves it" do
      assert Enum.count(Ephemera.all()) == 1
      assert Ephemera.fetch(@resource, "preexisting_key") == "preexisting_value"
      assert Enum.count(Ephemera.all()) == 1
    end

    test "taking existing key returns value and removes it" do
      assert Enum.count(Ephemera.all()) == 1
      Ephemera.take(@resource, "preexisting_key", &assert(&1 == "preexisting_value"))
      assert Enum.count(Ephemera.all()) == 0
    end

    test "delete existing key" do
      assert Enum.count(Ephemera.all()) == 1
      assert Ephemera.delete(@resource, "preexisting_key")
      assert Enum.count(Ephemera.all()) == 0
    end
  end
end
