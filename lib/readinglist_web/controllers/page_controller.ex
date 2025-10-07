defmodule ReadinglistWeb.PageController do
  use ReadinglistWeb, :controller
  alias Readinglist.BlogFetcher

  def home(conn, _params) do
    render(conn, :home)
  end

  def fetch(conn, %{"id" => id}) do
    url = BlogFetcher.build_url(id)
    BlogFetcher.refresh_reading_lists(url, conn.assigns.current_scope)
    conn |> redirect(to: ~p"/readinglist")
  end
end
