defmodule ReadinglistWeb.ReadinglistController do
  use ReadinglistWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:list, Readinglist.ReadingLists.list_list_items(conn.assigns.current_scope))
    |> render(:index)
  end
end
