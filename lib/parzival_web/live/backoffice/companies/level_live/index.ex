defmodule ParzivalWeb.Backoffice.LevelLive.Index do
<<<<<<< HEAD
  @moduledoc false
=======
>>>>>>> a83fe14 (Fix leaderboard)
  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Pagination

  alias Parzival.Companies
  alias Parzival.Companies.Level

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :companies)
     |> assign(:params, params)
     |> assign(list_levels(params))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Level")
    |> assign(:level, Companies.get_level!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Level")
    |> assign(:level, %Level{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Levels")
    |> assign(:level, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    level = Companies.get_level!(id)
    {:ok, _} = Companies.delete_level(level)

    {:noreply, assign(socket, list_levels(socket.assigns.params))}
  end

  @impl true
  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    params = build_search_map(socket.assigns.params, query)

    {:noreply, push_patch(socket, to: Routes.admin_level_index_path(socket, :index, params))}
  end

  defp build_search_map(params, text) do
    filters =
      (params["filters"] || %{})
      |> Map.put("1", %{"field" => "search", "value" => text, "op" => "ilike_or"})

    Map.put(params, "filters", filters)
  end

  defp list_levels(params) do
    case Companies.list_levels(params) do
      {:ok, {levels, meta}} ->
        %{levels: levels, meta: meta}

      {:error, flop} ->
        %{levels: [], meta: flop}
    end
  end
end
