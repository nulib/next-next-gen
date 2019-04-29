defmodule Meadow.Data.FileSet do
  use Ecto.Schema
  alias Meadow.Data.Image

  import Ecto.Changeset

  @primary_key {:id, Ecto.ULID, autogenerate: true}
  @foreign_key_type Ecto.ULID
  schema "file_sets" do
    field(:original_filename, :string)
    field(:location, :string)
    timestamps()

    belongs_to(:image, Image)
  end

  def changeset(file_set, params) do
    file_set
    |> cast(params, [:original_filename, :string])
    |> validate_required([:original_filename, :string])
  end
end
