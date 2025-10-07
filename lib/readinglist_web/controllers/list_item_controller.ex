defmodule ReadinglistWeb.ListItemController do
  use ReadinglistWeb, :controller

  alias Readinglist.ReadingLists

  def mark_as_read(conn, %{"id" => id}) do
    scope = conn.assigns.current_scope
    list_item = ReadingLists.get_list_item!(scope, id)

    case ReadingLists.update_list_item(scope, list_item, %{read: true}) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Item marked as read.")
        |> redirect(to: ~p"/readinglist")
      {:error, _} ->
        conn
        |> put_flash(:error, "Failed to mark item as read.")
        |> redirect(to: ~p"/readinglist")
    end
  end

  def mark_as_unread(conn, %{"id" => id}) do
    scope = conn.assigns.current_scope
    list_item = ReadingLists.get_list_item!(scope, id)

    case ReadingLists.update_list_item(scope, list_item, %{read: false}) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Item marked as unread.")
        |> redirect(to: ~p"/readinglist")
      {:error, _} ->
        conn
        |> put_flash(:error, "Failed to mark item as unread.")
        |> redirect(to: ~p"/readinglist")
    end
  end
end
