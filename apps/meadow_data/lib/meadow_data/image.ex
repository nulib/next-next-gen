defmodule Meadow.Data.Image do
  use Ecto.Schema
  alias Meadow.Data.{Collection, FileSet}

  import Ecto.Changeset

  @primary_key {:id, Ecto.ULID, autogenerate: true}
  @foreign_key_type Ecto.ULID
  schema "images" do
    field(:title, :string)
    field(:accession_number, :string)
    field(:ark, :string)
    field(:keyword, {:array, :string})
    timestamps()

    has_many(:file_sets, FileSet)
    many_to_many(:collections, Collection, join_through: "images_collections")
  end

  def changeset(image, params) do
    image
    |> cast(params, [:title, :accession_number, :ark, :keyword])
    |> validate_required([:title])
  end
end
