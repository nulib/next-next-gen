defmodule Meadow.Data.FileSet.Test do
  use Meadow.Data.RepoCase
  doctest Meadow.Data.FileSet

  alias Meadow.Data.FileSet

  describe "file_sets" do
    @valid_attrs %{
      original_filename: "test_file_set.txt",
      location: "Users/test/123"
    }
    @invalid_attrs %{original_filename: nil}

    test "fails with invalid attributes" do
      assert {:error, %Ecto.Changeset{}} =
               Meadow.Data.FileSet.changeset(%FileSet{}, @invalid_attrs) |> Repo.insert()
    end

    test "FileSet has a ULID identifier" do
      assert {:ok, %FileSet{} = file_set} =
               Meadow.Data.FileSet.changeset(%FileSet{}, @valid_attrs) |> Repo.insert()

      assert {:ok, <<data::binary-size(16)>>} = Ecto.ULID.dump(file_set.id)
    end
  end
end
