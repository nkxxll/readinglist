defmodule ReadinglistWeb.ReadinglistController do
  require Logger
  use ReadinglistWeb, :controller

  def index(conn, params) do
    scope = conn.assigns.current_scope
    query = params["query"] || ""
    read_filter = params["read_filter"] || "including"
    hidden_filter = params["hidden_filter"] || "including"

    filter_params = %{
      "query" => query,
      "read_filter" => read_filter,
      "hidden_filter" => hidden_filter
    }

    list = Readinglist.ReadingLists.list_list_items(scope, filter_params)
    Logger.info("Loaded #{length(list)} posts}")

    conn
    |> assign(:list, list)
    |> assign(:query, query)
    |> assign(:read_filter, read_filter)
    |> assign(:hidden_filter, hidden_filter)
    |> render(:index)
  end
end
