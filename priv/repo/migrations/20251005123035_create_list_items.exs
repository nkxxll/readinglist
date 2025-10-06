defmodule Readinglist.Repo.Migrations.CreateListItems do
  use Ecto.Migration

  def change do
    create table(:list_items) do
      add :title, :string
      add :description, :text
      add :source, :string
      add :parent, :string
      add :hidden, :boolean, default: false, null: false
      add :read, :boolean, default: false, null: false
      add :reading_list_id, references(:reading_lists, on_delete: :nothing)
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:list_items, [:user_id])

    create index(:list_items, [:reading_list_id])
  end
end
