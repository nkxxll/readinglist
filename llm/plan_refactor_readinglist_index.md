# Plan: Refactor Readinglist Index Page Components

## 1. Objective

Refactor recurring and logically grouped components within `lib/readinglist_web/controllers/readinglist_html/index.html.heex` into reusable Phoenix components. This will improve code readability, maintainability, and promote a cleaner separation of concerns.

## 2. Component Identification and Refactoring Strategy

We will identify three main areas for refactoring:

### 2.1. `ReadinglistFilterForm` Component

-   **Purpose**: To encapsulate the entire search and filter form, including the search input, submit button, and the read/hidden filter radio button groups.
-   **Location**: `lib/readinglist_web/components/readinglist_filter_form.ex`
-   **Props/Assigns**: This component will accept the current `@query`, `@read_filter`, and `@hidden_filter` values to pre-populate the form fields.
-   **Implementation Details**:
    -   It will contain the `<.form>` tag, the search input, the submit button, and the two `FilterRadioGroup` components (see 2.2).
    -   The `action` and `method` for the form will be hardcoded as `~p"/readinglist"` and `"get"` respectively.
-   **Usage Example in `index.html.heex`**:
    ```heex
    <.readinglist_filter_form query={@query} read_filter={@read_filter} hidden_filter={@hidden_filter} />
    ```

### 2.2. `FilterRadioGroup` Component

-   **Purpose**: To provide a reusable component for a group of three radio buttons ("Including", "Only", "Excluding") for a specific filter (e.g., "Read Status" or "Hidden Status").
-   **Location**: `lib/readinglist_web/components/filter_radio_group.ex`
-   **Props/Assigns**: This component will accept:
    -   `label`: The display label for the filter group (e.g., "Read:", "Hidden:").
    -   `name`: The `name` attribute for the radio buttons (e.g., "read_filter", "hidden_filter").
    -   `current_value`: The currently selected filter value (e.g., "including", "only", "excluding").
-   **Implementation Details**:
    -   It will render the `<span>` label and the three `<label>` elements containing the radio inputs.
    -   The `checked` attribute for each radio button will be set based on `current_value`.
-   **Usage Example within `ReadinglistFilterForm`**:
    ```heex
    <div class="flex justify-center gap-8 mt-4">
      <.filter_radio_group label="Read:" name="read_filter" current_value={@read_filter} />
      <.filter_radio_group label="Hidden:" name="hidden_filter" current_value={@hidden_filter} />
    </div>
    ```

### 2.3. `StatusToggleColumn` Component

-   **Purpose**: To encapsulate the logic for displaying an item's status (e.g., `read`, `hidden`) with a corresponding icon, and a toggle link/button that changes that status. This component will be used within the `<.table>`'s `<:col>` slots.
-   **Location**: `lib/readinglist_web/components/status_toggle_column.ex`
-   **Props/Assigns**: This component will accept:
    -   `item`: The `ListItem` struct.
    -   `status_field`: The atom representing the boolean field to check (e.g., `:hidden`, `:read`).
    -   `toggle_route_true`: The `~p` route for when the `status_field` is `true` (e.g., unhide, mark as unread).
    -   `toggle_route_false`: The `~p` route for when the `status_field` is `false` (e.g., hide, mark as read).
    -   `status_icon_true`: The `hero-icon` name to display when `status_field` is `true` (e.g., "hero-check").
    -   `status_icon_false`: The `hero-icon` name to display when `status_field` is `false` (e.g., "hero-x-mark").
    -   `toggle_icon_true`: The `hero-icon` name for the toggle link when `status_field` is `true` (e.g., "hero-eye" for unhide).
    -   `toggle_icon_false`: The `hero-icon` name for the toggle link when `status_field` is `false` (e.g., "hero-eye-slash" for hide).
-   **Implementation Details**:
    -   It will render the status icon and the conditional toggle link.
    -   The `method="post"` will be hardcoded for the toggle link.
-   **Usage Example in `index.html.heex`**:
    ```heex
    <:col :let={item} label="Hidden">
      <.status_toggle_column
        item={item}
        status_field={:hidden}
        toggle_route_true={~p"/list_item/toggle_hidden/#{item.id}"}
        toggle_route_false={~p"/list_item/toggle_hidden/#{item.id}"}
        status_icon_true="hero-check"
        status_icon_false="hero-x-mark"
        toggle_icon_true="hero-eye"
        toggle_icon_false="hero-eye-slash"
      />
    </:col>
    <:col :let={item} label="Read">
      <.status_toggle_column
        item={item}
        status_field={:read}
        toggle_route_true={~p"/list_item/unread/#{item.id}"}
        toggle_route_false={~p"/list_item/read/#{item.id}"}
        status_icon_true="hero-check"
        status_icon_false="hero-x-mark"
        toggle_icon_true="hero-x-circle"
        toggle_icon_false="hero-check-circle"
      />
    </:col>
    ```

## 3. Implementation Steps

1.  Create the new component files in `lib/readinglist_web/components/`.
2.  Implement the logic for each component as described above.
3.  Update `lib/readinglist_web/controllers/readinglist_html/index.html.heex` to use the new components, replacing the original inline code.
