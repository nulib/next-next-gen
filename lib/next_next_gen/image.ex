defmodule NextNextGen.Image do
  use Ecto.Schema
  alias NextNextGen.{Collection, File}

  import Ecto.Changeset

  schema "images" do
    field(:title, :string)
    field(:accession_number, :string)
    field(:ark, :string)
    field(:keyword, {:array, :string})
    timestamps()

    has_many(:files, File)
    many_to_many :collections, Collection, join_through: "images_collections"
  end

  def changeset(image, params) do
    image
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
