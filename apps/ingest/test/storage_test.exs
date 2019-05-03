defmodule MeadowIngestStorageTest do
  use ExUnit.Case
  doctest Meadow.Ingest.Storage

  describe "ephemeral storage" do
    alias Meadow.Ingest.Storage

    setup do
      [bucket: Application.get_env(:ingest, :storage_bucket)]
    end

    setup context do
      on_exit(fn ->
        ExAws.S3.delete_bucket(context[:bucket]) |> ExAws.request()
      end)
    end

    test "unconfigured" do
      assert {:error, _} = Storage.ensure_bucket_exists(:undefined)
    end

    test "bucket exists" do
      assert Storage.ensure_bucket_exists() == {:ok, :created}
      assert Storage.ensure_bucket_exists() == {:ok, :exists}
    end

    test "location generator", context do
      assert URI.to_string(Storage.location_for("ABCDE12345")) ==
               "s3://#{context[:bucket]}/AB/CD/E1/23/45/ABCDE12345"
    end
  end
end
