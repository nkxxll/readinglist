defmodule ReadinglistWeb.ReadinglistLive.Index do
  use ReadinglistWeb, :live_view

  alias Readinglist.ReadingLists

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    query = params["query"] || ""
    read_filter = params["read_filter"] || "including"
    hidden_filter = params["hidden_filter"] || "including"

    filter_params = %{
      "query" => query,
      "read_filter" => read_filter,
      "hidden_filter" => hidden_filter
    }

    list = ReadingLists.list_list_items(socket.assigns.current_scope, filter_params) |> ReadingLists.sort_reading_list()

    socket =
      socket
      |> assign(:query, query)
      |> assign(:read_filter, read_filter)
      |> assign(:hidden_filter, hidden_filter)
      |> stream(:list, list, reset: true)

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "filter",
        %{"query" => query, "read_filter" => read_filter, "hidden_filter" => hidden_filter},
        socket
      ) do
    params = %{
      "query" => query,
      "read_filter" => read_filter,
      "hidden_filter" => hidden_filter
    }

    {:noreply, push_patch(socket, to: ~p"/readinglist-live?#{params}")}
  end

  @impl true
  def handle_event("toggle_read", %{"id" => id}, socket) do
    id = String.to_integer(id)
    item = ReadingLists.get_list_item!(socket.assigns.current_scope, id)

    case ReadingLists.toggle_read_status(socket.assigns.current_scope, item) do
      {:ok, updated_item} ->
        socket =
          socket
          |> stream_insert(:list, updated_item)
          |> put_flash(:info, "Item read status updated")

        {:noreply, socket}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Failed to update item")}
    end
  end

  @impl true
  def handle_event("toggle_hidden", %{"id" => id}, socket) do
    id = String.to_integer(id)
    item = ReadingLists.get_list_item!(socket.assigns.current_scope, id)

    case ReadingLists.toggle_hidden_status(socket.assigns.current_scope, item) do
      {:ok, updated_item} ->
        socket =
          socket
          |> stream_insert(:list, updated_item)
          |> put_flash(:info, "Item hidden status updated")

        {:noreply, socket}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Failed to update item")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.form for={%{}} phx-change="filter" class="w-1/2 m-auto">
        <div class="flex items-center justify-center align-middle gap-2">
          <.input
            type="text"
            name="query"
            id="search-query"
            value={@query}
            placeholder="Search..."
            class="border rounded p-2 text-xl"
          />
          <%!-- <span class="text-xl text-green-400"> --%>
          <%!--   There are <span class="font-bold">{Integer.to_string(@streams.length)}</span> items loaded! --%>
          <%!-- </span> --%>
        </div>
        <div class="flex justify-center gap-8 mt-4">
          <div class="flex items-center gap-2">
            <span class="font-bold">Read:</span>
            <label class="flex items-center gap-1">
              <input
                type="radio"
                name="read_filter"
                value="including"
                checked={@read_filter == "including"}
                class="form-radio"
              /> Including
            </label>
            <label class="flex items-center gap-1">
              <input
                type="radio"
                name="read_filter"
                value="only"
                checked={@read_filter == "only"}
                class="form-radio"
              /> Only
            </label>
            <label class="flex items-center gap-1">
              <input
                type="radio"
                name="read_filter"
                value="excluding"
                checked={@read_filter == "excluding"}
                class="form-radio"
              /> Excluding
            </label>
          </div>
          <div class="flex items-center gap-2">
            <span class="font-bold">Hidden:</span>
            <label class="flex items-center gap-1">
              <input
                type="radio"
                name="hidden_filter"
                value="including"
                checked={@hidden_filter == "including"}
                class="form-radio"
              /> Including
            </label>
            <label class="flex items-center gap-1">
              <input
                type="radio"
                name="hidden_filter"
                value="only"
                checked={@hidden_filter == "only"}
                class="form-radio"
              /> Only
            </label>
            <label class="flex items-center gap-1">
              <input
                type="radio"
                name="hidden_filter"
                value="excluding"
                checked={@hidden_filter == "excluding"}
                class="form-radio"
              /> Excluding
            </label>
          </div>
        </div>
      </.form>

      <div class="w-full flex flex-col items-center overflow-x-auto">
        <.table
          id="reading-list"
          rows={@streams.list}
          row_id={
            fn item ->
              {id, _item} = item
              id
            end
          }
        >
          <:col :let={{_id, item}} label="Title">
            <div class="font-bold w-48 truncate">{item.title}</div>
          </:col>
          <:col :let={{_id, item}} label="Description">
            <div class="max-h-24 overflow-y-auto w-[40rem]">
              {item.description}
            </div>
          </:col>
          <:col :let={{_id, item}} label="Source">
            <div class="w-64 break-all">
              <.link href={item.source} target="_blank">{item.source}</.link>
            </div>
          </:col>
          <:col :let={{_id, item}} label="Parent">
            <div class="w-32 break-all">{item.parent}</div>
          </:col>
          <:col :let={{_id, item}} label="Hidden">
            <div class="flex items-center w-16">
              <span>
                <%= if item.hidden do %>
                  <.icon name="hero-check" class="h-5 w-5 text-green-500" />
                <% else %>
                  <.icon name="hero-x-mark" class="h-5 w-5 text-red-500" />
                <% end %>
              </span>
              <span class="ml-2">
                <button
                  phx-click="toggle_hidden"
                  phx-value-id={item.id}
                  class="text-gray-400 hover:text-gray-600"
                >
                  <%= if item.hidden do %>
                    <.icon name="hero-eye" class="h-5 w-5" />
                  <% else %>
                    <.icon name="hero-eye-slash" class="h-5 w-5" />
                  <% end %>
                </button>
              </span>
            </div>
          </:col>
          <:col :let={{_id, item}} label="Read">
            <div class="flex items-center w-16">
              <span>
                <%= if item.read do %>
                  <.icon name="hero-check" class="h-5 w-5 text-green-500" />
                <% else %>
                  <.icon name="hero-x-mark" class="h-5 w-5 text-red-500" />
                <% end %>
              </span>
              <span class="ml-2">
                <button
                  phx-click="toggle_read"
                  phx-value-id={item.id}
                  class="text-gray-400 hover:text-gray-600"
                >
                  <%= if item.read do %>
                    <.icon name="hero-x-circle" class="h-5 w-5" />
                  <% else %>
                    <.icon name="hero-check-circle" class="h-5 w-5" />
                  <% end %>
                </button>
              </span>
            </div>
          </:col>
        </.table>
      </div>
    </Layouts.app>
    """
  end
end
