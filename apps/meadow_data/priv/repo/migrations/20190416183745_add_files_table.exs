defmodule Meadow.Data.Repo.Migrations.AddFileSetsTable do
  use Ecto.Migration

  def change do
    create table(:file_sets, primary_key: false) do
      add(:id, :binary_id, null: false, primary_key: true)
      add(:original_filename, :string)
      add(:location, :string)
      add(:image_id, references(:images, type: :binary_id))

      timestamps()
    end
  end
end
