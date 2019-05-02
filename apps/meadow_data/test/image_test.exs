defmodule Meadow.Data.Image.Test do
  use Meadow.Data.RepoCase
  doctest Meadow.Data.Image

  alias Meadow.Data.Image

  describe "images" do
    @valid_attrs %{title: "Test image", accession_number: "123", keyword: "test"}
    @invalid_attrs %{title: nil}

    test "fails with invalid attributes" do
      assert {:error, %Ecto.Changeset{}} =
               Meadow.Data.Image.changeset(%Image{}, @invalid_attrs) |> Repo.insert()
    end

    test "Image has a ULID identifier" do
      assert {:ok, %Image{} = image} =
               Meadow.Data.Image.changeset(%Image{}, @valid_attrs) |> Repo.insert()

      assert {:ok, <<data::binary-size(16)>>} = Ecto.ULID.dump(image.id)
    end
  end
end
