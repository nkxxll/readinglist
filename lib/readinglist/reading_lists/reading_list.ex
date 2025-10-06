defmodule Readinglist.ReadingLists.ReadingList do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reading_lists" do
    field :name, :string

    belongs_to :user, Readinglist.Accounts.User
    has_many :list_items, Readinglist.ReadingLists.ListItem

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reading_list, attrs, user_scope) do
    reading_list
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> put_change(:user_id, user_scope.user.id)
  end
end
