defmodule NextNextGen.Collection do
  import Ecto.Changeset
  use Ecto.Schema

  schema "collections" do
    field(:title, :string)
    field(:description, :string)
    field(:ark, :string)
    timestamps()
  end

  def changeset(collection, params) do
    collection
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
