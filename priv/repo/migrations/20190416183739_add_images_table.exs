defmodule NextNextGen.Repo.Migrations.AddImagesTable do
  use Ecto.Migration

  def change do
    create table(:images) do
      add(:title, :string)
      add(:accession_number, :string)
      add(:ark, :string)
      add(:keyword, {:array, :string}, default: [])

      create(unique_index(:images, [:accession_number]))
    end
  end
end
