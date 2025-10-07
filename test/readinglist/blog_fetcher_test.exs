defmodule Readinglist.BlogFetcherTest do
  use ExUnit.Case, async: true
  alias Readinglist.BlogFetcher
  import Readinglist.BlogFetcherFixtures

  @tag fetch_test: "parse"
  test "test the parse_document/2 function" do
    result = BlogFetcher.parse_document("example.url.com", example_blog_list_for_parsing(0))
    assert {:ok, items} = result
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

  test "test the parse_document/2 function real" do
    result = BlogFetcher.parse_document("example.url.com", example_blog_list_for_parsing(1))
    assert {:ok, items} = result
    items_string = inspect(items)
    assert items_string == "[%{parent: \"example.url.com\", description: \"My favorite this week: matklad’sInverse Triangle Inequality. Small commits, small refactors, small releases. Yes, yes, yes.\", title: \"Inverse Triangle Inequality\", source: \"https://matklad.github.io/2025/07/07/inverse-triangle-inequality.html\"}]"
  end
end
