defmodule Readinglist.ReadingLists do
  @moduledoc """
  The ReadingLists context.
  """

  require Logger
  import Ecto.Query, warn: false
  alias Readinglist.Repo

  alias Readinglist.Accounts.User
  alias Readinglist.ReadingLists.ReadingList
  alias Readinglist.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any reading_list changes.

  The broadcasted messages match the pattern:

    * {:created, %ReadingList{}}
    * {:updated, %ReadingList{}}
    * {:deleted, %ReadingList{}}

  """
  def subscribe_reading_lists(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Readinglist.PubSub, "user:#{key}:reading_lists")
  end

  defp broadcast_reading_list(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Readinglist.PubSub, "user:#{key}:reading_lists", message)
  end

  @doc """
  Returns the list of reading_lists.

  ## Examples

      iex> list_reading_lists(scope)
      [%ReadingList{}, ...]

  """
  def list_reading_lists(%Scope{} = scope) do
    Repo.all_by(ReadingList, user_id: scope.user.id)
  end

  @doc """
  Gets a single reading_list.

  Raises `Ecto.NoResultsError` if the Reading list does not exist.

  ## Examples

      iex> get_reading_list!(scope, 123)
      %ReadingList{}

      iex> get_reading_list!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_reading_list!(%Scope{} = scope, id) do
    Repo.get_by!(ReadingList, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a reading_list.

  ## Examples

      iex> create_reading_list(scope, %{field: value})
      {:ok, %ReadingList{}}

      iex> create_reading_list(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reading_list(%Scope{} = scope, attrs) do
    with {:ok, reading_list = %ReadingList{}} <-
           %ReadingList{}
           |> ReadingList.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_reading_list(scope, {:created, reading_list})
      {:ok, reading_list}
    end
  end

  @doc """
  Updates a reading_list.

  ## Examples

      iex> update_reading_list(scope, reading_list, %{field: new_value})
      {:ok, %ReadingList{}}

      iex> update_reading_list(scope, reading_list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reading_list(%Scope{} = scope, %ReadingList{} = reading_list, attrs) do
    true = reading_list.user_id == scope.user.id

    with {:ok, reading_list = %ReadingList{}} <-
           reading_list
           |> ReadingList.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_reading_list(scope, {:updated, reading_list})
      {:ok, reading_list}
    end
  end

  @doc """
  Deletes a reading_list.

  ## Examples

      iex> delete_reading_list(scope, reading_list)
      {:ok, %ReadingList{}}

      iex> delete_reading_list(scope, reading_list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reading_list(%Scope{} = scope, %ReadingList{} = reading_list) do
    true = reading_list.user_id == scope.user.id

    with {:ok, reading_list = %ReadingList{}} <-
           Repo.delete(reading_list) do
      broadcast_reading_list(scope, {:deleted, reading_list})
      {:ok, reading_list}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reading_list changes.

  ## Examples

      iex> change_reading_list(scope, reading_list)
      %Ecto.Changeset{data: %ReadingList{}}

  """
  def change_reading_list(%Scope{} = scope, %ReadingList{} = reading_list, attrs \\ %{}) do
    true = reading_list.user_id == scope.user.id

    ReadingList.changeset(reading_list, attrs, scope)
  end

  alias Readinglist.ReadingLists.ListItem
  alias Readinglist.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any list_item changes.

  The broadcasted messages match the pattern:

    * {:created, %ListItem{}}
    * {:updated, %ListItem{}}
    * {:deleted, %ListItem{}}

  """
  def subscribe_list_items(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Readinglist.PubSub, "user:#{key}:list_items")
  end

  defp broadcast_list_item(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Readinglist.PubSub, "user:#{key}:list_items", message)
  end

  @doc """
  Returns the list of list_items.

  ## Examples

      iex> list_list_items(scope)
      [%ListItem{}, ...]

  """
  def list_list_items(%Scope{} = scope) do
    Repo.all_by(ListItem, user_id: scope.user.id)
  end

  @doc """
  Gets a single list_item.

  Raises `Ecto.NoResultsError` if the List item does not exist.

  ## Examples

      iex> get_list_item!(scope, 123)
      %ListItem{}

      iex> get_list_item!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_list_item!(%Scope{} = scope, id) do
    Repo.get_by!(ListItem, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a list_item.

  ## Examples

      iex> create_list_item(scope, %{field: value})
      {:ok, %ListItem{}}

      iex> create_list_item(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list_item(%Scope{} = scope, attrs) do
    with {:ok, list_item = %ListItem{}} <-
           %ListItem{}
           |> ListItem.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_list_item(scope, {:created, list_item})
      {:ok, list_item}
    end
  end

  @doc """
  Updates a list_item.

  ## Examples

      iex> update_list_item(scope, list_item, %{field: new_value})
      {:ok, %ListItem{}}

      iex> update_list_item(scope, list_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list_item(%Scope{} = scope, %ListItem{} = list_item, attrs) do
    true = list_item.user_id == scope.user.id

    with {:ok, list_item = %ListItem{}} <-
           list_item
           |> ListItem.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_list_item(scope, {:updated, list_item})
      {:ok, list_item}
    end
  end

  @doc """
  Deletes a list_item.

  ## Examples

      iex> delete_list_item(scope, list_item)
      {:ok, %ListItem{}}

      iex> delete_list_item(scope, list_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list_item(%Scope{} = scope, %ListItem{} = list_item) do
    true = list_item.user_id == scope.user.id

    with {:ok, list_item = %ListItem{}} <-
           Repo.delete(list_item) do
      broadcast_list_item(scope, {:deleted, list_item})
      {:ok, list_item}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list_item changes.

  ## Examples

      iex> change_list_item(scope, list_item)
      %Ecto.Changeset{data: %ListItem{}}

  """
  def change_list_item(%Scope{} = scope, %ListItem{} = list_item, attrs \\ %{}) do
    true = list_item.user_id == scope.user.id

    ListItem.changeset(list_item, attrs, scope)
  end

  @doc """
  Returns a list of all users that have at least one reading list.
  """
  def list_users_with_reading_lists do
    query =
      from u in User,
        join: l in ReadingList,
        on: l.user_id == u.id,
        group_by: u.id,
        select: u

    Repo.all(query)
  end

  @doc """
  Adds a new item to a user's reading list if an item with the same source URL doesn't already exist.

  It will add the item to the user's first reading list.
  """
  def add_item_if_new(user, post) do
    Logger.info("We are in the add item if new method")

    reading_list =
      case Repo.get_by(ReadingList, user_id: user.id) do
        nil ->
          Logger.info("default list got created")
          # No reading list exists → create a default one
          {:ok, default} =
            %ReadingList{
              user_id: user.id,
              name: "Default"
            }
            |> Repo.insert()

          default

        list ->
          list
      end

    # Check if the item already exists for this user
    exists? =
      from(i in ListItem,
        where:
          i.user_id == ^user.id and i.source == ^post.source and
            i.description == ^post.description
      )
      |> Repo.exists?()

    # Only create the item if it doesn’t exist
    unless exists? do
      scope = %Scope{user: user}

      attrs = %{
        title: post.title,
        source: post.source,
        description: post.description,
        reading_list_id: reading_list.id
      }

      Logger.info("Item got added to default list #{inspect(attrs)}")

      create_list_item(scope, attrs)
    end
  end
end
