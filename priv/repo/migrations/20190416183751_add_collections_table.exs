defmodule NextNextGen.Repo.Migrations.AddCollectionsTable do
  use Ecto.Migration

  def change do
    create table(:collections, primary_key: false) do
      add(:id, :binary_id, null: false, primary_key: true)
      add(:title, :string)
      add(:description, :text)
      add(:ark, :string)

      timestamps()
    end
  end
end
