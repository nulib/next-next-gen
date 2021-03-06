defmodule Meadow.Data.Repo.Migrations.AddImagesTable do
  use Ecto.Migration

  def change do
    create table(:images, primary_key: false) do
      add(:id, :binary_id, null: false, primary_key: true)
      add(:title, :string)
      add(:accession_number, :string)
      add(:ark, :string)
      add(:keyword, {:array, :string}, default: [])

      timestamps()
    end

    create(unique_index(:images, [:accession_number]))
  end
end
