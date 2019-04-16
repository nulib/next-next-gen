defmodule NextNextGen.Repo.Migrations.AddFilesTable do
  use Ecto.Migration

  def change do
    create table(:files) do
      add(:original_filename, :string)
      add(:location, :string)
      add(:image_id, references(:images))

      timestamps()
    end
  end
end
