defmodule Meadow.Data.Repo.Migrations.AddImagesCollectionsTable do
  use Ecto.Migration

  def change do
    create table(:images_collections, primary_key: false) do
      add(:image_id, references(:images, type: :binary_id))
      add(:collection_id, references(:collections, type: :binary_id))
    end

    create(index(:images_collections, :image_id))
    create(index(:images_collections, :collection_id))
  end
end
