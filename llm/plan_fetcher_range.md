# Plan to Fetch Blog Posts for a Range of IDs

## Objective

Modify the blog fetcher to support fetching posts for a range of IDs, handle errors gracefully, and display the results of each fetch operation to the user.

## Plan

### 1. Frontend Changes (`lib/readinglist_web/controllers/page_html/home.html.heex`)

- Update the form to accept a `start_id` and an `end_id` to define the range.
- This will replace the single `id` input.

**Example:**
```heex
<.form :let={f} for={%{}} action={~p"/fetch"} method="post">
  <div class="flex items-center gap-2">
    <.input field={f[:start_id]} type="number" name="start_id" label="Start ID" />
    <.input field={f[:end_id]} type="number" name="end_id" label="End ID" />
  </div>
  <button>Fetch Blogs</button>
</.form>
```

### 2. Controller Changes (`lib/readinglist_web/controllers/page_controller.ex`)

- The `fetch/2` function will be updated to handle `start_id` and `end_id` from the parameters.
- It will parse the IDs, create a range, and iterate over it.
- For each ID, it will call a new `BlogFetcher.safe_refresh_reading_lists/2` function.
- The results (success or failure) for each ID will be collected.
- Flash messages will be generated based on the results and displayed to the user on the home page.

**Example:**
```elixir
def fetch(conn, %{"start_id" => start_id, "end_id" => end_id}) do
  start_id = String.to_integer(start_id)
  end_id = String.to_integer(end_id)

  results = 
    (start_id..end_id)
    |> Enum.map(fn id ->
      BlogFetcher.safe_refresh_reading_lists(id, conn.assigns.current_scope)
    end)

  success_count = Enum.count(results, &match?({:ok, _}, &1))
  error_count = Enum.count(results, &match?({:error, _, _}, &1))

  conn
  |> put_flash(:info, "Fetched #{success_count} blogs successfully.")
  |> put_flash(:error, "Failed to fetch #{error_count} blogs.")
  |> redirect(to: ~p"/")
end
```

### 3. Blog Fetcher Changes (`lib/readinglist/blog_fetcher.ex`)

- A new function `safe_refresh_reading_lists/2` will be created.
- This function will take an `id` and the `scope`.
- It will wrap the call to `refresh_reading_lists/2` in a `try/rescue` block to catch any errors during the fetching and parsing process.
- It will return `{:ok, id}` on success and `{:error, id, reason}` on failure.
- The existing `refresh_reading_lists/2` will be updated to return the result from `fetch_new_posts` instead of pattern matching on it, allowing the error to be propagated up.

**Example `safe_refresh_reading_lists/2`:**
```elixir
def safe_refresh_reading_lists(id, %Scope{} = scope) do
  try do
    url = build_url(id)
    refresh_reading_lists(url, scope)
    {:ok, id}
  rescue
    e -> {:error, id, e}
  end
end
```

**Example `refresh_reading_lists/2` modification:**
```elixir
def refresh_reading_lists(url, %Scope{} = scope) do
  Logger.info("Refreshing reading lists from #{url}...")

  with {:ok, posts} <- fetch_new_posts(url) do
    Logger.info("Got post list with len #{length(posts)}")

    Enum.each(posts, fn post ->
      ReadingLists.add_item_if_new(scope.user, post)
    end)
  end
end
```
