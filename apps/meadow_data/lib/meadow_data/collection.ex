defmodule Meadow.Data.Collection do
  import Ecto.Changeset
  use Ecto.Schema
  alias Meadow.Data.Image

  @primary_key {:id, Ecto.ULID, autogenerate: true}
  @foreign_key_type Ecto.ULID
  schema "collections" do
    field(:title, :string)
    field(:description, :string)
    field(:ark, :string)
    timestamps()
    many_to_many(:images, Image, join_through: "images_collections")
  end

  def changeset(collection, params) do
    collection
    |> cast(params, [:title, :description, :ark])
    |> validate_required([:title])
  end
end
