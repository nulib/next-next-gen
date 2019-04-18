defmodule NextNextGen.Collection.Test do
  use ExUnit.Case
  use NextNextGen.RepoCase
  doctest NextNextGen.Collection

  describe "collections" do
    alias NextNextGen.Collection

    @basic_attrs %{title: "Spec", description: "Test Collection"}

    test "Collection has a ULID identifier" do
      assert {:ok, %Collection{} = collection} =
               NextNextGen.Collection.changeset(%Collection{}, @basic_attrs) |> Repo.insert()

      assert {:ok, <<data::binary-size(16)>>} = Ecto.ULID.dump(collection.id)
    end
  end
end
