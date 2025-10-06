defmodule Readinglist.ReadingLists.ListItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "list_items" do
    field :title, :string
    field :description, :string
    field :source, :string
    field :parent, :string
    field :hidden, :boolean, default: false
    field :read, :boolean, default: false
    belongs_to :reading_list, Readinglist.ReadingLists.ReadingList
    belongs_to :user, Readinglist.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(list_item, attrs, user_scope) do
    list_item
    |> cast(attrs, [:title, :description, :source, :hidden, :read, :reading_list_id])
    |> validate_required([:title, :source, :reading_list_id])
    |> foreign_key_constraint(:reading_list_id)
    |> put_change(:user_id, user_scope.user.id)
  end
end
