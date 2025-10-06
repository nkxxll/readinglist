defmodule Readinglist.BlogFetcherFixtures do
  def example_blog_list_for_parsing do
    ~S(
      <div class="available-content">
        <div>
          <ul>
            <li><a href="http://example.com/1">Title 1</a> Description 1</li>
            <li><a href="http://example.com/2">Title 2</a> Description 2</li>
          </ul>
        </div>
      </div>
    )
  end
end