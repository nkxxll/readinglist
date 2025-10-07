# Plan to Implement "Mark as Read" Feature

This document outlines the plan to implement the "mark as read" functionality for items in the reading list.

## 1. Frontend Changes (`index.html.heex`)

In `lib/readinglist_web/controllers/readinglist_html/index.html.heex`, the `Source` column of the table will be modified. The source URL, which is currently displayed as text, will be converted into a clickable link.

This link will trigger a `POST` request to a new endpoint (`/list_item/read/:id`) to mark the item as read. We will use Phoenix's `<.link>` component with `method="post"`.

**Example:**
```heex
<:col :let={item} label="Source">
  <.link href={~p"/list_item/read/#{item.id}"} method="post" data-confirm="Mark as read?">{item.source}</.link>
</:col>
```
I'll also change the `Read` column to be a link to mark as unread if it is already read.

## 2. Routing (`router.ex`)

A new route will be added to `lib/readinglist_web/router.ex` to handle the `POST` request.

```elixir
scope "/", ReadinglistWeb do
  pipe_through :browser # Or whichever pipe handles auth

  # ...
  post "/list_item/read/:id", ListItemController, :mark_as_read
  post "/list_item/unread/:id", ListItemController, :mark_as_unread
end
```

## 3. Controller (`list_item_controller.ex`)

A new controller, `ReadinglistWeb.ListItemController`, will be created at `lib/readinglist_web/controllers/list_item_controller.ex`.

This controller will have the `mark_as_read` action. This action will:
1.  Receive the `id` of the `ListItem`.
2.  Use `conn.assigns.current_scope` to get the current user's scope.
3.  Call `Readinglist.ReadingLists.get_list_item!/2` to fetch the item.
4.  Call `Readinglist.ReadingLists.update_list_item/3` with `%{read: true}`.
5.  Redirect the user back to the reading list page (`/readinglist`) with a flash message.

A `mark_as_unread` action will also be added.

**Example:**
```elixir
defmodule ReadinglistWeb.ListItemController do
  use ReadinglistWeb, :controller

  alias Readinglist.ReadingLists

  def mark_as_read(conn, %{"id" => id}) do
    scope = conn.assigns.current_scope
    list_item = ReadingLists.get_list_item!(scope, id)

    case ReadingLists.update_list_item(scope, list_item, %{read: true}) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Item marked as read.")
        |> redirect(to: ~p"/readinglist")
      {:error, _} ->
        conn
        |> put_flash(:error, "Failed to mark item as read.")
        |> redirect(to: ~p"/readinglist")
    end
  end

  def mark_as_unread(conn, %{"id" => id}) do
    # similar logic to mark as unread
  end
end
```

## 4. Context (`reading_lists.ex`)

The existing `Readinglist.ReadingLists.update_list_item/3` function in `lib/readinglist/reading_lists.ex` already handles updating the `ListItem` and broadcasting the `{:updated, list_item}` message via `Phoenix.PubSub`.

This means that after the item is updated, any subscribed client (like a LiveView) will receive the update. For the current user who clicked the link, the page will update due to the redirect.

No changes are required in this file.
