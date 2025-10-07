defmodule Readinglist.ReadingListsTest do
  use Readinglist.DataCase

  alias Readinglist.ReadingLists

  describe "reading_lists" do
    alias Readinglist.ReadingLists.ReadingList

    import Readinglist.AccountsFixtures, only: [user_scope_fixture: 0]
    import Readinglist.ReadingListsFixtures

    @invalid_attrs %{name: nil}

    test "list_reading_lists/1 returns all scoped reading_lists" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      reading_list = reading_list_fixture(scope)
      other_reading_list = reading_list_fixture(other_scope)
      assert ReadingLists.list_reading_lists(scope) == [reading_list]
      assert ReadingLists.list_reading_lists(other_scope) == [other_reading_list]
    end

    test "get_reading_list!/2 returns the reading_list with given id" do
      scope = user_scope_fixture()
      reading_list = reading_list_fixture(scope)
      other_scope = user_scope_fixture()
      assert ReadingLists.get_reading_list!(scope, reading_list.id) == reading_list

      assert_raise Ecto.NoResultsError, fn ->
        ReadingLists.get_reading_list!(other_scope, reading_list.id)
      end
    end

    test "create_reading_list/2 with valid data creates a reading_list" do
      valid_attrs = %{name: "some name"}
      scope = user_scope_fixture()

      assert {:ok, %ReadingList{} = reading_list} =
               ReadingLists.create_reading_list(scope, valid_attrs)

      assert reading_list.name == "some name"
      assert reading_list.user_id == scope.user.id
    end

    test "create_reading_list/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = ReadingLists.create_reading_list(scope, @invalid_attrs)
    end

    test "update_reading_list/3 with valid data updates the reading_list" do
      scope = user_scope_fixture()
      reading_list = reading_list_fixture(scope)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %ReadingList{} = reading_list} =
               ReadingLists.update_reading_list(scope, reading_list, update_attrs)

      assert reading_list.name == "some updated name"
    end

    test "update_reading_list/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      reading_list = reading_list_fixture(scope)

      assert_raise MatchError, fn ->
        ReadingLists.update_reading_list(other_scope, reading_list, %{})
      end
    end

    test "update_reading_list/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      reading_list = reading_list_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               ReadingLists.update_reading_list(scope, reading_list, @invalid_attrs)

      assert reading_list == ReadingLists.get_reading_list!(scope, reading_list.id)
    end

    test "delete_reading_list/2 deletes the reading_list" do
      scope = user_scope_fixture()
      reading_list = reading_list_fixture(scope)
      assert {:ok, %ReadingList{}} = ReadingLists.delete_reading_list(scope, reading_list)

      assert_raise Ecto.NoResultsError, fn ->
        ReadingLists.get_reading_list!(scope, reading_list.id)
      end
    end

    test "delete_reading_list/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      reading_list = reading_list_fixture(scope)

      assert_raise MatchError, fn ->
        ReadingLists.delete_reading_list(other_scope, reading_list)
      end
    end

    test "change_reading_list/2 returns a reading_list changeset" do
      scope = user_scope_fixture()
      reading_list = reading_list_fixture(scope)
      assert %Ecto.Changeset{} = ReadingLists.change_reading_list(scope, reading_list)
    end
  end

  describe "list_items" do
    alias Readinglist.ReadingLists.ListItem

    import Readinglist.AccountsFixtures, only: [user_scope_fixture: 0]
    import Readinglist.ReadingListsFixtures

    @invalid_attrs %{hidden: nil, read: nil, description: nil, title: nil, source: nil}

    test "list_list_items/1 returns all scoped list_items" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      list_item = list_item_fixture(scope)
      other_list_item = list_item_fixture(other_scope)
      assert ReadingLists.list_list_items(scope) == [list_item]
      assert ReadingLists.list_list_items(other_scope) == [other_list_item]
    end

    test "get_list_item!/2 returns the list_item with given id" do
      scope = user_scope_fixture()
      list_item = list_item_fixture(scope)
      other_scope = user_scope_fixture()
      assert ReadingLists.get_list_item!(scope, list_item.id) == list_item

      assert_raise Ecto.NoResultsError, fn ->
        ReadingLists.get_list_item!(other_scope, list_item.id)
      end
    end

    test "create_list_item/2 with valid data creates a list_item" do
      scope = user_scope_fixture()
      reading_list = reading_list_fixture(scope)

      valid_attrs = %{
        hidden: true,
        read: true,
        description: "some description",
        title: "some title",
        source: "some source",
        reading_list_id: reading_list.id
      }

      assert {:ok, %ListItem{} = list_item} = ReadingLists.create_list_item(scope, valid_attrs)
      assert list_item.hidden == true
      assert list_item.read == true
      assert list_item.description == "some description"
      assert list_item.title == "some title"
      assert list_item.source == "some source"
      assert list_item.user_id == scope.user.id
    end

    test "create_list_item/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = ReadingLists.create_list_item(scope, @invalid_attrs)
    end

    test "update_list_item/3 with valid data updates the list_item" do
      scope = user_scope_fixture()
      list_item = list_item_fixture(scope)

      update_attrs = %{
        hidden: false,
        read: false,
        description: "some updated description",
        title: "some updated title",
        source: "some updated source"
      }

      assert {:ok, %ListItem{} = list_item} =
               ReadingLists.update_list_item(scope, list_item, update_attrs)

      assert list_item.hidden == false
      assert list_item.read == false
      assert list_item.description == "some updated description"
      assert list_item.title == "some updated title"
      assert list_item.source == "some updated source"
    end

    test "update_list_item/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      list_item = list_item_fixture(scope)

      assert_raise MatchError, fn ->
        ReadingLists.update_list_item(other_scope, list_item, %{})
      end
    end

    test "update_list_item/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      list_item = list_item_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               ReadingLists.update_list_item(scope, list_item, @invalid_attrs)

      assert list_item == ReadingLists.get_list_item!(scope, list_item.id)
    end

    test "delete_list_item/2 deletes the list_item" do
      scope = user_scope_fixture()
      list_item = list_item_fixture(scope)
      assert {:ok, %ListItem{}} = ReadingLists.delete_list_item(scope, list_item)
      assert_raise Ecto.NoResultsError, fn -> ReadingLists.get_list_item!(scope, list_item.id) end
    end

    test "delete_list_item/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      list_item = list_item_fixture(scope)
      assert_raise MatchError, fn -> ReadingLists.delete_list_item(other_scope, list_item) end
    end

    test "change_list_item/2 returns a list_item changeset" do
      scope = user_scope_fixture()
      list_item = list_item_fixture(scope)
      assert %Ecto.Changeset{} = ReadingLists.change_list_item(scope, list_item)
    end
  end
end
