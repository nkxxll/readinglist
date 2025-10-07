defmodule ReadinglistWeb.ReadinglistController do
  require Logger
  use ReadinglistWeb, :controller

  def index(conn, _params) do
    list = Readinglist.ReadingLists.list_list_items(conn.assigns.current_scope)
    Logger.info("Loaded #{length(list)} posts}")

    conn
    |> assign(:list, list)
    |> render(:index)
  end
end
