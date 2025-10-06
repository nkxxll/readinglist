defmodule Readinglist.ReadingListsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Readinglist.ReadingLists` context.
  """

  @doc """
  Generate a reading_list.
  """
  def reading_list_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "some name"
      })

    {:ok, reading_list} = Readinglist.ReadingLists.create_reading_list(scope, attrs)
    reading_list
  end

  @doc """
  Generate a list_item.
  """
  def list_item_fixture(scope, attrs \\ %{}) do
    reading_list = reading_list_fixture(scope)

    attrs =
      Enum.into(attrs, %{
        description: "some description",
        hidden: true,
        read: true,
        source: "some source",
        title: "some title",
        reading_list_id: reading_list.id
      })

    {:ok, list_item} = Readinglist.ReadingLists.create_list_item(scope, attrs)

    list_item
  end
end
