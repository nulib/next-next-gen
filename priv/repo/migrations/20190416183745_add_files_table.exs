defmodule NextNextGen.Repo.Migrations.AddFilesTable do
  use Ecto.Migration

  def change do
    create table(:files) do
      add(:original_filename, :string)
      add(:location, :string)
      add(:images_id, references(:images))
    end
  end
end
