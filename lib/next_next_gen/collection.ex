defmodule NextNextGen.Collection do
  import Ecto.Changeset
  use Ecto.Schema
  alias NextNextGen.Image

  schema "collections" do
    field(:title, :string)
    field(:description, :string)
    field(:ark, :string)
    timestamps()
    many_to_many :images, Image, join_through: "images_collections"
  end

  def changeset(collection, params) do
    collection
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
