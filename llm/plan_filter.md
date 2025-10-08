# Plan: Add Filtering and Hiding to Reading List

## 1. Objective

Enhance the reading list page with filtering capabilities for "read" and "hidden" items, and add a feature to hide individual items from the list.

## 2. Backend Changes

### 2.1. `ReadingLists` Context (`lib/readinglist/reading_lists.ex`)

- **Modify `list_items/1`:**
  - This function currently takes search parameters. It will be updated to also accept `read_filter` and `hidden_filter` params.
  - The function will construct a dynamic Ecto query.
  - **`read_filter` logic:**
    - `"including"` (default): No filter applied on the `read` field.
    - `"only"`: Add `where: query.read == true`.
    - `"excluding"`: Add `where: query.read == false`.
  - **`hidden_filter` logic:**
    - `"including"` (default): No filter applied on the `hidden` field.
    - `"only"`: Add `where: query.hidden == true`.
    - `"excluding"`: Add `where: query.hidden == false`.

- **Add `hide_item/1`:**
  - Create a new function `hide_item(item)` that takes a `ListItem` and updates its `hidden` attribute to `true`.

### 2.2. `ReadinglistController` (`lib/readinglist_web/controllers/readinglist_controller.ex`)

- **Update `index/2`:**
  - Extract `read_filter` and `hidden_filter` from the `params`. Provide default values ("including").
  - Pass these filters to `ReadingLists.list_items/1`.
  - Assign the current filter values to the connection (`@read_filter`, `@hidden_filter`) so they can be used to set the state of the filter UI in the template.

### 2.3. `ListItemController` (`lib/readinglist_web/controllers/list_item_controller.ex`)

- **Add `hide/2` function:**
  - This function will handle the request from the new "Hide" button.
  - It will get the `ListItem` using the `id` from the params.
  - It will call the new `ReadingLists.hide_item/1` function.
  - It will redirect back to the reading list page.

## 3. Frontend Changes

### 3.1. `index.html.heex`

- **Add Filter UI:**
  - Inside the existing `<.form>`, add two sets of radio buttons or a dropdown select for "Read Status" and "Hidden Status".
  - Each filter will have three options:
    - `Including` (value: "including")
    - `Only` (value: "only")
    - `Excluding` (value: "excluding")
  - The form's `method` is already "get", so submitting will add the filter values to the URL as query parameters. The form should automatically submit when a filter is changed.

- **Add "Hide" Button:**
  - In the table row for each item, add a new column or action for "Hide".
  - This will be a link or button that makes a `POST` request to the new `/list_item/hide/:id` route. It should look similar to the existing mark as read/unread buttons.
  - Example:
    ```heex
    <.link href={~p"/list_item/hide/#{item.id}"} method="post">
      <.icon name="hero-eye-slash" class="h-5 w-5 text-gray-400" />
    </.link>
    ```

## 4. Routing

### 4.1. `router.ex` (`lib/readinglist_web/router.ex`)

- **Add Hide Route:**
  - Add a new route to handle the hide action within the authenticated scope.
  - `post "/list_item/hide/:id", ListItemController, :hide`

## 5. Migration/Schema Verification

- Before starting, I will verify that the `hidden` field exists and is a boolean on the `list_items` table and in the `ListItem` Ecto schema. The existing template code suggests it's already there, so no changes are anticipated.
