# Search Implementation Plan

## Objective

Implement a search functionality on the reading list index page (`/readinglist`). This will allow users to filter the list of items based on a search query.

## Plan

The implementation will be done in three parts:

1.  **Frontend:** Add a search form to the `index.html.heex` template.
2.  **Controller:** Update the `ReadinglistController` to handle the search query.
3.  **Backend:** Modify the `ReadingLists` context to filter the reading list items based on the search query.

---

### 1. Frontend Changes (`lib/readinglist_web/controllers/readinglist_html/index.html.heex`)

-   Add a `<.form>` component at the top of the page, before the table.
-   The form will be for a `:search` changeset/map and will submit a `GET` request to the current page (`~p"/readinglist"`).
-   Inside the form, add a text input field for the search query. The `name` of the input will be `search[query]`.
-   Add a submit button to trigger the search.
-   The page should display the current search query, if any.

**Example:**

```html
<.form for={:search} action={~p"/readinglist"} method="get">
  <.input type="text" name="search[query]" value={@query} placeholder="Search..." />
  <.button type="submit">Search</.button>
</.form>
```

---

### 2. Controller Logic (`lib/readinglist_web/controllers/readinglist_controller.ex`)

-   The `index/2` function in `ReadinglistController` will be updated to handle the `search` parameter from the `GET` request.
-   The controller will extract the search query from the `params`.
-   It will then call the `ReadingLists.list_items/1` function, passing the search query.
-   The controller will assign the search query to the socket to be available in the template for displaying the current search term.

**Example:**

```elixir
def index(conn, %{"search" => %{"query" => query}} = _params) do
  list = ReadingLists.list_items(query)
  render(conn, :index, list: list, query: query)
end

def index(conn, _params) do
  list = ReadingLists.list_items()
  render(conn, :index, list: list, query: nil)
end
```

---

### 3. Backend Logic (`lib/readinglist/reading_lists.ex`)

-   The `list_items/0` function will be updated to `list_items/1` to accept an optional search query.
-   If a search query is provided, an Ecto `where` clause will be added to the query to filter the `ListItem`s.
-   The search will be case-insensitive and will match against the `title` and `description` fields.

**Example:**

```elixir
def list_items(search_query \ nil) do
  query = from l in ListItem, order_by: [desc: l.inserted_at]

  query =
    if search_query do
      from l in query,
        where:
          ilike(l.title, ^"%#{search_query}%") or
            ilike(l.description, ^"%#{search_query}%")
    else
      query
    end

  Repo.all(query)
end
```
