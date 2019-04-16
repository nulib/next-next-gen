defmodule NextNextGen.Repo.Migrations.AddCollectionsTable do
  use Ecto.Migration

  def change do
    create table(:collections) do
      add(:title, :string)
      add(:description, :text)
      add(:ark, :string)

      timestamps()
    end
  end
end
