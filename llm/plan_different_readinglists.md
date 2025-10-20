# Plan for Implementing Multi-Reading List Feature

This document outlines the plan to add the capability for users to manage multiple reading lists.

## Phase 1: Core Reading List Management (CRUD)

1.  **Update ReadingLists Context:**
    *   In `lib/readinglist/reading_lists.ex`, add the following functions to handle CRUD operations for `ReadingList`s, ensuring they are scoped to the current user.
        *   `list_reading_lists(scope)`: Returns all reading lists for the user.
        *   `get_reading_list(id, scope)`: Gets a single reading list.
        *   `create_reading_list(attrs, scope)`: Creates a new reading list.
        *   `update_reading_list(reading_list, attrs, scope)`: Updates a reading list.
        *   `delete_reading_list(reading_list, scope)`: Deletes a reading list.

2.  **Create ReadingList Controller:**
    *   Create a new controller `lib/readinglist_web/controllers/reading_list_controller.ex`.
    *   Implement the standard `index`, `new`, `create`, `edit`, `update`, and `delete` actions.
    *   These actions will call the functions defined in the `Readinglist.ReadingLists` context.

3.  **Add Routes:**
    *   In `lib/readinglist_web/router.ex`, add a new resource to handle the reading list CRUD operations within the authenticated scope:
        ```elixir
        resources "/reading_lists", ReadingListController
        ```

4.  **Create Views and Templates:**
    *   Create a new directory `lib/readinglist_web/templates/reading_list`.
    *   Add templates for `index.html.heex`, `new.html.heex`, `edit.html.heex`, and a `form.html.heex` partial.
    *   The `index` page will list all the user's reading lists with links to view, edit, and delete them.
    *   The `new` and `edit` pages will use the `form` partial to create and update reading lists.

## Phase 2: Default Reading List and Item Display

1.  **User Onboarding:**
    *   Modify the `Readinglist.Accounts.register_user/1` function to automatically create a "Default" reading list when a new user is created.

2.  **Refactor `ReadinglistController` to `ListItemController`:**
    *   Rename `lib/readinglist_web/controllers/readinglist_controller.ex` to `lib/readinglist_web/controllers/list_item_controller.ex`.
    *   Rename the module inside the file from `ReadinglistWeb.ReadinglistController` to `ReadinglistWeb.ListItemController`.
    *   Update the router in `lib/readinglist_web/router.ex`. The old `get "/", ReadinglistController, :index` will be changed.

3.  **Update Routes for Items:**
    *   The index of list items should be nested under a reading list. The new route will look like `/reading_lists/:id`.
    *   In `lib/readinglist_web/router.ex`, change the route to be:
        ```elixir
        get "/reading_lists/:id", ReadinglistController, :show
        ```
    *   The `ReadinglistController` will have a `show` action that displays the items for a given reading list. The existing `index` action from `ReadinglistController` will become the `show` action.

4.  **Update `ReadinglistController` (The new one for lists):**
    *   The `show` action will take a `reading_list_id` as a parameter.
    *   It will fetch the reading list and its items.
    *   It will render a template that displays the list items.

5.  **Homepage Redirect:**
    *   The `PageController`'s `home` action should fetch the user's default reading list and redirect to the `ReadinglistController#show` page for that list.

## Phase 3: Managing List Items within Reading Lists

1.  **ListItem Context:**
    *   The `Readinglist.ReadingLists.create_list_item/3` function already accepts a `reading_list_id`. This will be used to associate new items with the correct list.

2.  **"Add Item" Functionality:**
    *   The form for adding a new list item will need to include a `reading_list_id` (this can be a hidden field).
    *   The `ListItemController`'s `create` action will use this `reading_list_id` when creating the new item.

3.  **ListItem Actions:**
    *   All actions in `ListItemController` (`create`, `update`, `delete`) need to be aware of the current `reading_list_id` to ensure items are managed within the correct list.

## Phase 4: UI/UX Enhancements

1.  **Navigation:**
    *   In the main layout (`root.html.heex`), add a dropdown menu or a sidebar that lists all the user's reading lists, allowing them to easily switch between them.
    *   This navigation element should link to the `ReadinglistController#show` action for each list.

2.  **Visual Cues:**
    *   The current reading list's name should be prominently displayed on the list item view page.
    *   Add a link to manage reading lists (to `ReadingListController#index`) from the main navigation.
