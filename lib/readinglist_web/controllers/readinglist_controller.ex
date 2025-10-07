defmodule ReadinglistWeb.ReadinglistController do
  require Logger
  use ReadinglistWeb, :controller

  def index(conn, %{"search" => %{"query" => query}}) do
    list = Readinglist.ReadingLists.list_list_items(conn.assigns.current_scope, query)
    Logger.info("Loaded #{length(list)} posts for query '#{query}'}")

    conn
    |> assign(:list, list)
    |> assign(:query, query)
    |> render(:index)
  end

  def index(conn, _params) do
    list = Readinglist.ReadingLists.list_list_items(conn.assigns.current_scope)
    Logger.info("Loaded #{length(list)} posts}")

    conn
    |> assign(:list, list)
    |> assign(:query, nil)
    |> render(:index)
  end
end
