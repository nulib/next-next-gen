defmodule Meadow.Data.File do
  use Ecto.Schema
  alias Meadow.Data.Image

  import Ecto.Changeset

  @primary_key {:id, Ecto.ULID, autogenerate: true}
  @foreign_key_type Ecto.ULID
  schema "files" do
    field(:original_filename, :string)
    field(:location, :string)
    timestamps()

    belongs_to(:image, Image)
  end

  def changeset(file, params) do
    file
    |> cast(params, [:original_filename, :string])
    |> validate_required([:original_filename, :string])
  end
end