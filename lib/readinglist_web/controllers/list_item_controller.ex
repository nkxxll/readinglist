defmodule ReadinglistWeb.ListItemController do
  use ReadinglistWeb, :controller

  alias Readinglist.ReadingLists

  def get_search_params(params) do
    query = params["query"] || ""
    read_filter = params["read_filter"] || "including"
    hidden_filter = params["hidden_filter"] || "including"

    %{
      query: query,
      read_filter: read_filter,
      hidden_filter: hidden_filter
    }
  end

  def redirect_search(conn, path, search_params) do
    conn |> redirect(to: path <> "?" <> URI.encode_query(search_params))
  end

  def mark_as_read(conn, %{"id" => id} = params) do
    scope = conn.assigns.current_scope
    search_params = get_search_params(params)

    list_item = ReadingLists.get_list_item!(scope, id)

    case ReadingLists.update_list_item(scope, list_item, %{read: true}) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Item marked as read.")
        |> redirect_search(~p"/readinglist", search_params)

      {:error, _} ->
        conn
        |> put_flash(:error, "Failed to mark item as read.")
        |> redirect_search(~p"/readinglist", search_params)
    end
  end

  def mark_as_unread(conn, %{"id" => id} = params) do
    scope = conn.assigns.current_scope
    search_params = get_search_params(params)
    list_item = ReadingLists.get_list_item!(scope, id)

    case ReadingLists.update_list_item(scope, list_item, %{read: false}) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Item marked as unread.")
        |> redirect_search(~p"/readinglist", search_params)

      {:error, _} ->
        conn
        |> put_flash(:error, "Failed to mark item as unread.")
        |> redirect_search(~p"/readinglist", search_params)
    end
  end

  def toggle_hidden(conn, %{"id" => id} = params) do
    scope = conn.assigns.current_scope
    search_params = get_search_params(params)
    list_item = ReadingLists.get_list_item!(scope, id)

    case ReadingLists.toggle_hidden_status(scope, list_item) do
      {:ok, updated_item} ->
        message = if updated_item.hidden, do: "Item hidden.", else: "Item unhidden."

        conn
        |> put_flash(:info, message)
        |> redirect_search(~p"/readinglist", search_params)

      {:error, _} ->
        conn
        |> put_flash(:error, "Failed to update item.")
        |> redirect_search(~p"/readinglist", search_params)
    end
  end
end
