defmodule NextNextGen.File do
  use Ecto.Schema
  alias NextNextGen.Image

  import Ecto.Changeset

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
