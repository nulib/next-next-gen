defmodule Meadow.Data.FileSet.Test do
  use Meadow.Data.RepoCase

  doctest Meadow.Data.FileSet

  alias Meadow.Data.FileSet

  describe "file_sets" do
    setup do
      image =
        Meadow.Data.Image.changeset(%Meadow.Data.Image{}, %{
          title: "FileSet Container"
        })
        |> Repo.insert!()

      [
        valid_attrs: %{
          image_id: image.id,
          original_filename: "test_file_set.txt",
          location: "Users/test/123"
        },
        invalid_attrs: %{original_filename: nil}
      ]
    end

    test "fails with invalid attributes", context do
      assert {:error, %Ecto.Changeset{}} =
               Meadow.Data.FileSet.changeset(%FileSet{}, context[:invalid_attrs]) |> Repo.insert()
    end

    test "FileSet has a ULID identifier", context do
      assert {:ok, %FileSet{} = file_set} =
               Meadow.Data.FileSet.changeset(%FileSet{}, context[:valid_attrs]) |> Repo.insert()

      assert {:ok, <<data::binary-size(16)>>} = Ecto.ULID.dump(file_set.id)
    end
  end
end
