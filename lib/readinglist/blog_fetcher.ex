defmodule Readinglist.BlogFetcher do
  @moduledoc """
  Handles fetching and parsing blog posts from external sources.
  """

  alias Readinglist.ReadingLists

  @blog_url Application.compile_env(:readinglist, [:blog, :base_url])
  @blog_prefix Application.compile_env(:readinglist, [:blog, :blog_prefix])

  def build_url(number) do
    "#{@blog_url}#{@blog_prefix}#{number}"
  end

  def refresh_reading_lists(url) do
    IO.puts("Refreshing reading lists from #{url}...")

    posts = fetch_new_posts(url)

    for user <- ReadingLists.list_users_with_reading_lists() do
      Enum.each(posts, fn post ->
        ReadingLists.add_item_if_new(user, post)
      end)
    end
  end

  defp fetch_new_posts(url) do
    {:ok, response} = Req.get(url)
    parse_document(url, response.body)
  end

  def parse_document(url, document) do
    {:ok, document} = Floki.parse_document(document)

    Floki.find(document, "div.available-content div ul li")
    |> Enum.map(fn li ->
      link = Floki.find(li, "a")

      %{
        title: Floki.text(link),
        source: Floki.attribute(link, "href") |> List.first(),
        parent: url,
        description: Floki.text(li)
      }
    end)
  end
end
