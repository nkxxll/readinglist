# Implementation Plan: LiveView Reading List Migration

## Overview

This plan outlines the step-by-step process to migrate the existing reading list feature from a traditional Phoenix controller-based implementation to a Phoenix LiveView implementation. The migration aims to provide a real-time, responsive user experience by handling interactions over a persistent WebSocket connection, eliminating full page reloads for search, filtering, and item status updates.

Based on the research in `research_live_view_readinglist.md`, this plan focuses on creating a stateful LiveView that manages UI state, handles events, and synchronizes with URL parameters for bookmarkable and shareable filtered views.

## Prerequisites

- Ensure `phoenix_live_view` is properly configured and available in the project dependencies.
- Verify that the existing business logic in `Readinglist.ReadingLists` is well-isolated and can be reused without modifications.
- Confirm that the project follows Phoenix v1.8 guidelines, including proper use of `Layouts.app` and component imports.

## Implementation Steps

### Step 1: Create the LiveView Module

1. Create a new file: `lib/readinglist_web/live/readinglist_live/index.ex`
2. Define the `ReadinglistWeb.ReadinglistLive.Index` module that uses `Phoenix.LiveView`
3. Implement the basic LiveView structure with empty callbacks (`mount/3`, `handle_params/3`, `handle_event/3`, `render/1`)

### Step 2: Implement State Management

1. Identify the current state variables from the controller implementation:
   - Query parameters: `query`, `read_filter`, `hidden_filter`
   - Data: List of reading list items
   - Additional UI state: Loading states, error states if needed

2. Define initial assigns in the LiveView:
   - `:query` - String for search term
   - `:read_filter` - Atom or string for read status filter
   - `:hidden_filter` - Atom or string for hidden status filter
   - `:list` - List of reading list items (consider using streams for better performance)
   - `:loading` - Boolean for loading state

### Step 3: Implement Lifecycle Callbacks

#### 3.1 `mount/3` Function
1. Extract initial parameters from the session (if any)
2. Set up default assigns for query parameters
3. Delegate to `handle_params/3` for initial data loading

#### 3.2 `handle_params/3` Function
1. Parse URL parameters (`query`, `read_filter`, `hidden_filter`)
2. Validate and sanitize parameters
3. Update socket assigns with parsed parameters
4. Fetch filtered data from `Readinglist.ReadingLists.list_items/1`
5. Assign the fetched data to the socket
6. Handle edge cases: empty results, invalid parameters

#### 3.3 `handle_event/3` Functions
1. Implement `"filter"` event handler for search and filter form changes:
   - Extract form parameters
   - Use `push_patch/2` to update URL with new parameters
   - Let `handle_params/3` handle the actual filtering

2. Implement `"toggle_read"` event handler:
   - Extract item ID from event parameters
   - Call `Readinglist.ReadingLists.update_list_item/2` to toggle read status
   - Update the specific item in the socket assigns (or stream)
   - Handle success/error cases with flash messages

3. Implement `"toggle_hidden"` event handler:
   - Similar to toggle_read, but for hidden status

### Step 4: Convert and Update Templates

1. Create a new template file: `lib/readinglist_web/live/readinglist_live/index.html.heex`
2. Copy the existing template content from `lib/readinglist_web/controllers/readinglist_html/index.html.heex`
3. Update the template to work with LiveView assigns instead of controller assigns

#### 4.1 Form Updates
1. Change the search/filter form to use `phx-change="filter"` instead of `method="get"`
2. Remove form submission logic
3. Ensure form inputs are bound to LiveView assigns

#### 4.2 Interactive Elements
1. Replace POST links for toggling read/hidden status with `phx-click` attributes
2. Add appropriate `phx-value-*` attributes to pass item IDs
3. Update element IDs for LiveView-specific testing

#### 4.3 Layout Integration
1. Ensure the template starts with `<Layouts.app flash={@flash} ...>` as per guidelines
2. Pass `current_scope` if the route requires authentication (confirm routing requirements)

### Step 5: Update Routing

1. Open `lib/readinglist_web/router.ex`
2. Locate the existing controller route: `get "/readinglist", ReadinglistController, :index`
3. Replace it with: `live "/readinglist", ReadinglistLive.Index`
4. Ensure the route is placed in the appropriate `live_session` block (likely `:require_authenticated_user` if authentication is required)
5. Verify that `current_scope` is properly handled in the LiveView

### Step 6: Implement Data Fetching Logic

1. Create helper functions in the LiveView for data fetching:
   - `fetch_items/1` - Takes socket assigns and fetches items using `Readinglist.ReadingLists.list_items/1`
   - `apply_filters/1` - Builds filter parameters from socket assigns

2. Ensure proper error handling for data fetching failures
3. Consider implementing pagination if the dataset is large

### Step 7: Optimize with Streams (Optional but Recommended)

1. Convert the list assignment to use LiveView streams for better performance
2. Update template to use `phx-update="stream"` and `@streams.list`
3. Modify event handlers to use `stream_insert/4`, `stream_delete/2`, etc. for item updates

### Step 8: Add Loading States and Error Handling

1. Implement loading indicators during data fetching
2. Add error states for failed operations
3. Use flash messages for user feedback on actions

### Step 9: Testing Implementation

1. Create LiveView tests in `test/readinglist_web/live/readinglist_live_test.exs`
2. Test initial mounting and parameter handling
3. Test filter form interactions
4. Test item status toggling
5. Test URL synchronization with filters
6. Ensure existing controller tests still pass (or are removed if route is fully migrated)

### Step 10: Performance and Security Considerations

1. Implement proper authorization checks using `@current_scope.user`
2. Add rate limiting if needed for frequent filter changes
3. Monitor memory usage due to stateful nature
4. Consider implementing caching for frequently accessed data

### Step 11: Migration and Deployment

1. Deploy the LiveView alongside the existing controller
2. Use feature flags or gradual rollout if needed
3. Monitor for issues in production
4. Remove old controller code once migration is complete and tested

## Risk Assessment and Mitigation

### High Memory Usage
- **Risk**: Stateful LiveView processes consume more server memory
- **Mitigation**: Implement proper process cleanup, monitor memory usage, consider clustering

### URL Synchronization Issues
- **Risk**: Filters not properly reflected in URL
- **Mitigation**: Rigorous testing of `handle_params/3` and `push_patch/2` usage

### Business Logic Coupling
- **Risk**: Accidental coupling between UI and business logic
- **Mitigation**: Keep all data operations in the context module, use LiveView only for UI state

### Testing Complexity
- **Risk**: LiveView testing is more complex than controller testing
- **Mitigation**: Follow Phoenix LiveView testing best practices, use proper element selectors

## Success Criteria

- All user interactions (search, filter, toggle actions) work without page reloads
- URLs remain bookmarkable and shareable with filter state
- Performance is improved or maintained compared to controller version
- All existing functionality is preserved
- Tests pass and cover new LiveView functionality
- Code follows Phoenix and Elixir best practices

## Rollback Plan

If issues arise during deployment:
1. Keep the old controller route active as a backup
2. Monitor error rates and performance metrics
3. Have a quick rollback script to revert routing changes
4. Document any data inconsistencies that might occur during the transition

## Timeline Estimate

- Step 1-3: 1-2 days (Core LiveView implementation)
- Step 4-5: 1 day (Template and routing updates)
- Step 6-8: 1-2 days (Data handling and optimizations)
- Step 9: 2-3 days (Testing)
- Step 10-11: 1 day (Deployment and monitoring)

Total estimated time: 6-9 days for a single developer, depending on complexity and testing requirements.
