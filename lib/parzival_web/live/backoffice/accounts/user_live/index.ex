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
end
