
# Research: Live View Reading List

## 1. Problem Statement

The current reading list feature is implemented using a traditional Phoenix controller (`ReadinglistController`). Every user interaction, such as searching or applying filters, triggers a full HTTP request/response cycle, resulting in a complete page reload. This approach is not ideal for a feature that is meant to be highly interactive.

Migrating to Phoenix LiveView will solve this by providing a real-time, responsive user experience. User interactions will be handled over a persistent WebSocket connection, allowing the server to update only the parts of the page that have changed, without needing a full page reload. This makes the application feel faster and more modern.

## 2. Analysis of Existing Implementation

- **Controller (`lib/readinglist_web/controllers/readinglist_controller.ex`):** This is the entry point. The `index` function is responsible for fetching filter parameters from the `conn`, calling the business logic to get the data, and rendering the final HTML.
- **HTML Template (`lib/readinglist_web/controllers/readinglist_html/index.html.heex`):** This file contains the complete HEEx template for the page. It includes the search/filter form and the table that displays the reading list items. Interactions are handled via a standard HTML form submission (`method="get"`) and links that trigger POST requests for actions like toggling item status.
- **Business Logic (`lib/readinglist/reading_lists.ex`):** The core logic for querying and filtering reading list items is correctly isolated in this module. This module can be reused by the new LiveView without modification.

## 3. Proposed LiveView Approach

### a. Create a new LiveView Module

A new module, `ReadinglistWeb.ReadinglistLive.Index`, will be created. This will be a stateful LiveView process.

### b. State Management

The state currently managed by controller assigns and passed through URL params (`query`, `read_filter`, `hidden_filter`) will be held in the LiveView's `socket.assigns`. The list of items will also be stored in the assigns.

### c. Lifecycle and Event Handling

- **`mount/3`:** This function will be the entry point for the LiveView. It will replace the controller's `index` action. It will receive the initial URL parameters, set up the initial state in the socket, and perform the first data fetch from `Readinglist.ReadingLists`.
- **`handle_params/3`:** This callback is crucial for making the LiveView's state bookmarkable and shareable. It will be triggered on `mount` and whenever the URL changes (via `live_patch`). It will parse the query parameters from the URL, update the socket assigns, and re-fetch the list of items. This is the correct place to contain the logic for reacting to filter changes.
- **`handle_event/3`:** This will handle user interactions.
    - A `phx-change` event on the filter form will trigger an event (e.g., `"filter"`). Instead of submitting the form, this event handler will use `Phoenix.LiveView.push_patch/2` to update the URL with the new filter parameters. This will, in turn, trigger `handle_params`, which will apply the filters and update the list.
    - Actions like toggling the "read" or "hidden" status of an item will be handled by `phx-click` events. These event handlers will call the relevant context function (e.g., `Readinglist.ReadingLists.update_list_item/2`) and then update the specific item in the `socket.assigns.list`, causing only that row in the table to re-render.

### d. Template Conversion

The existing `index.html.heex` template can be largely reused. It will be converted to a LiveView template (`.html.leex` or remain `.html.heex` and be rendered by the LiveView).

- The `<.form>` will be updated to use `phx-change` to trigger live updates.
- The radio buttons and search input will no longer need to be part of a form that submits to the server. Their state will be controlled by the LiveView.
- The links for toggling "read" and "hidden" will be changed from `method="post"` links to elements with `phx-click` attributes.

### e. Routing

The router file (`lib/readinglist_web/router.ex`) will be updated to replace the `get "/readinglist", ReadinglistController, :index` route with a `live "/readinglist", ReadinglistLive.Index` route.

## 4. Key Design Trade-offs & Constraints

- **Statefulness:** The primary trade-off is moving from a stateless controller model to a stateful LiveView model. This increases server memory usage because a process is kept alive for each connected user. However, it dramatically simplifies state management for interactive features and is the core benefit of LiveView.
- **URL Synchronization:** It is important to keep the URL in sync with the current filters. Using `push_patch` (or `live_patch`) is the standard LiveView pattern for this. It ensures that users can bookmark and share links to filtered views of the data.
- **Dependencies:** The project already has `phoenix_live_view` as a dependency, so no new external dependencies are required.
- **Data Fetching:** The existing `Readinglist.ReadingLists` context module is the single source of truth for data and should continue to be used. The LiveView acts as the UI layer on top of this existing business logic.
