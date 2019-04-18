defmodule NextNextGen.Repo.Migrations.AddImagesCollectionsTable do
  use Ecto.Migration

  def change do
    create table(:images_collections) do
      add(:image_id, references(:images))
      add(:collection_id, references(:collections))
    end

    create(index(:images_collections, :image_id))
    create(index(:images_collections, :collection_id))
  end
end
