defmodule Readinglist.BlogFetcher do
  @moduledoc """
  Handles fetching and parsing blog posts from external sources.
  """

  require Logger
  alias Readinglist.ReadingLists
  alias Readinglist.Accounts.Scope

  @blog_url Application.compile_env(:readinglist, [:blog, :base_url])
  @blog_prefix Application.compile_env(:readinglist, [:blog, :blog_prefix])

  def build_url(number) do
    "#{@blog_url}#{@blog_prefix}#{number}"
  end

  def refresh_reading_lists(url, %Scope{} = scope) do
    Logger.info("Refreshing reading lists from #{url}...")

    # TODO: this is a result we need to catch that
    {:ok, posts} = fetch_new_posts(url)
    Logger.info("Got List #{inspect(posts)}")

    Enum.each(posts, fn post ->
      ReadingLists.add_item_if_new(scope.user, post)
    end)
  end

  defp fetch_new_posts(url) do
    {:ok, response} = Req.get(url)
    parse_document(url, response.body)
  end

  @spec parse_document(String.t(), binary()) :: {:ok, list()} | {:error, String.t()}
  def parse_document(url, document) do
    case Floki.parse_document(document) do
      {:ok, document} ->
        case Floki.find(document, "div.available-content div ul li")
             |> Enum.map(fn li ->
               link = Floki.find(li, "a")

               source =
                 case Floki.attribute(link, "href") do
                   [] -> "no source"
                   [h | _] -> h
                 end

               %{
                 title: Floki.text(link),
                 source: source,
                 parent: url,
                 description: Floki.text(li)
               }
             end) do
          [] -> {:error, "no elements"}
          other -> {:ok, other}
        end

      {:error, error} ->
        {:error, error}
    end
  end
end
