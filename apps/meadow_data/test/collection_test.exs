defmodule Meadow.Data.Collection.Test do
  use Meadow.Data.RepoCase
  doctest Meadow.Data.Collection

  @valid_attrs %{title: "Spec", description: "Test Collection"}
  @invalid_attrs %{title: nil}

  describe "collections" do
    alias Meadow.Data.Collection

    test "fails with invalid attributes" do
      assert {:error, %Ecto.Changeset{}} =
               Meadow.Data.Collection.changeset(%Collection{}, @invalid_attrs) |> Repo.insert()
    end

    test "Collection has a ULID identifier" do
      assert {:ok, %Collection{} = collection} =
               Meadow.Data.Collection.changeset(%Collection{}, @valid_attrs) |> Repo.insert()

      assert {:ok, <<data::binary-size(16)>>} = Ecto.ULID.dump(collection.id)
    end
  end
end
