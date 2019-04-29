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

  @spec changeset(
          {map(), map()}
          | %{:__struct__ => atom() | %{__changeset__: map()}, optional(atom()) => any()},
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  def changeset(image, params) do
    image
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
