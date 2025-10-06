defmodule Readinglist.BlogFetcherTest do
  alias Readinglist.BlogFetcher

  import Readinglist.BlogFetcherFixtures
  @tag fetch_test: "parse"
  test "test the parse_document/2 function" do
    item = parse_document("example.url.com", @example_blog_list)
  end
end
