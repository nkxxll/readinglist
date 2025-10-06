defmodule Readinglist.BlogFetcherTest do
  use ExUnit.Case, async: true
  alias Readinglist.BlogFetcher
  import Readinglist.BlogFetcherFixtures

  @tag fetch_test: "parse"
  test "test the parse_document/2 function" do
    items = BlogFetcher.parse_document("example.url.com", example_blog_list_for_parsing())
    assert [item1, item2] = items

    assert item1.title == "Title 1"
    assert item1.source == "http://example.com/1"
    assert item1.parent == "example.url.com"
    assert item1.description == "Title 1 Description 1"

    assert item2.title == "Title 2"
    assert item2.source == "http://example.com/2"
    assert item2.parent == "example.url.com"
    assert item2.description == "Title 2 Description 2"
  end
end