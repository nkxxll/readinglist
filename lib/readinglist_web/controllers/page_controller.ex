defmodule ReadinglistWeb.PageController do
  use ReadinglistWeb, :controller
  alias Readinglist.BlogFetcher

  def home(conn, _params) do
    render(conn, :home)
  end

  def fetch(conn, %{"start_id" => start_id, "end_id" => end_id}) do
    case Integer.parse(start_id) do
      {start_id_int, _} ->
        end_id_int =
          case Integer.parse(end_id) do
            {int, _} -> int
            :error -> start_id_int
          end

        results =
          (start_id_int..end_id_int)
          |> Enum.map(fn id ->
            BlogFetcher.safe_refresh_reading_lists(id, conn.assigns.current_scope)
          end)

        success_count = Enum.count(results, &match?({:ok, _}, &1))
        error_count = Enum.count(results, &match?({:error, _, _}, &1))

        conn =
          if success_count > 0 do
            put_flash(conn, :info, "Fetched #{success_count} blogs successfully.")
          else
            conn
          end

        conn =
          if error_count > 0 do
            put_flash(conn, :error, "Failed to fetch #{error_count} blogs.")
          else
            conn
          end

        redirect(conn, to: ~p"/")

      :error ->
        conn
        |> put_flash(:error, "Invalid Start ID. Please provide a number.")
        |> redirect(to: ~p"/")
    end
  end
end