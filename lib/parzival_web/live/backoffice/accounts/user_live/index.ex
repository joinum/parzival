defmodule ParzivalWeb.Backoffice.UserLive.Index do
  @moduledoc false

  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Pagination

  alias Parzival.Accounts

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, list_users(params))}
  end

  @impl true
  def handle_params(
        %{"filters" => %{"0" => %{"field" => "role", "value" => role}}} = params,
        _url,
        socket
      ) do
    tab =
      case role do
        "admin" -> :admin
        "staff" -> :staff
        "attendee" -> :attendee
        "recruiter" -> :recruiter
      end

    {:noreply,
     socket
     |> assign(:current_page, :accounts)
     |> assign(:current_tab, tab)
     |> assign(:params, params)
     |> assign(list_users(params))}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    params = %{"filters" => %{"0" => %{"field" => "role", "value" => "attendee"}}}

    {:noreply,
     socket
     |> assign(:current_page, :accounts)
     |> assign(:current_tab, :attendee)
     |> assign(:params, params)
     |> assign(list_users(params))}
  end

  @impl true
  def handle_event("assign_user", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)

    {:noreply,
     socket
     |> assign(:user, user)}
  end

  @impl true
  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    params = build_search_map(socket.assigns.params, query)

    {:noreply, push_patch(socket, to: Routes.admin_user_index_path(socket, :index, params))}
  end

  defp list_users(params) do
    params =
      params
      |> Map.put("page_size", 8)

    case Accounts.list_users(params, preloads: :company) do
      {:ok, {users, meta}} ->
        %{users: users, meta: meta}

      {:error, flop} ->
        %{users: [], meta: flop}
    end
  end

  defp build_search_map(params, text) do
    filters =
      (params["filters"] || %{})
      |> Map.put("1", %{"field" => "search", "value" => text, "op" => "ilike_or"})

    Map.put(params, "filters", filters)
  end

  def user_list_entry(assigns) do
    ~H"""
    <li id={"user-#{assigns.user.id}"} class="relative pl-4 pr-6 border-b border-gray-200 sm:pl-6 lg:pl-8 xl:pl-6 hover:bg-gray-50">
      <div class="flex justify-between">
        <div class="py-4 pl-4 pr-3 text-sm whitespace-nowrap sm:pl-6">
          <div class="flex items-center">
            <div class="flex-shrink-0 w-10 h-10">
              <%= if is_nil(Parzival.Uploaders.ProfilePicture.url({assigns.user.picture, assigns.user}, :original)) do %>
                <span class="inline-flex items-center justify-center w-10 h-10 rounded-full bg-secondary">
                  <span class="text-lg font-medium leading-none text-white">
                    <%= extract_initials(assigns.user.name) %>
                  </span>
                </span>
              <% else %>
                <div class="relative flex-shrink-0 w-10 h-10 bg-white rounded-full">
                  <img src={Parzival.Uploaders.ProfilePicture.url({assigns.user.picture, assigns.user}, :original)} class="object-center w-10 h-10 rounded-full" />
                </div>
              <% end %>
            </div>
            <div class="ml-4">
              <div class="font-medium text-gray-900">
                <%= assigns.user.name %>
              </div>
              <div class="text-gray-500">
                <%= case @assigns.current_tab do %>
                  <% :attendee -> %>
                    <%= assigns.user.cycle %> in <%= assigns.user.course %>
                  <% :recruiter -> %>
                    <%= assigns.user.company.name %>
                  <% _ -> %>
                    <%= assigns.user.email %>
                <% end %>
              </div>
            </div>
          </div>
        </div>
      </div>
    </li>
    """
  end
end
