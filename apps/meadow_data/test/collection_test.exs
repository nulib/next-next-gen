defmodule Meadow.Data.Collection.Test do
  use ExUnit.Case
  use Meadow.Data.RepoCase
  doctest Meadow.Data.Collection

  describe "collections" do
    alias Meadow.Data.Collection

    @basic_attrs %{title: "Spec", description: "Test Collection"}

    test "Collection has a ULID identifier" do
      assert {:ok, %Collection{} = collection} =
               Meadow.Data.Collection.changeset(%Collection{}, @basic_attrs) |> Repo.insert()

      assert {:ok, <<data::binary-size(16)>>} = Ecto.ULID.dump(collection.id)
    end
  end
end
