defmodule ParzivalWeb.Backoffice.OfferTimeLive.Index do
  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Pagination

  alias Parzival.Companies
  alias Parzival.Companies.OfferTime

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :jobs)
     |> assign(:params, params)
     |> assign(list_offer_times(params))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Time")
    |> assign(:offer_time, Companies.get_offer_time!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Time")
    |> assign(:offer_time, %OfferTime{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Times")
    |> assign(:offer_time, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    offer_time = Companies.get_offer_time!(id)
    {:ok, _} = Companies.delete_offer_time(offer_time)

    {:noreply, assign(socket, list_offer_times(%{}))}
  end

  @impl true
  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    params = build_search_map(socket.assigns.params, query)

    {:noreply, push_patch(socket, to: Routes.admin_offer_time_index_path(socket, :index, params))}
  end

  defp build_search_map(params, text) do
    filters =
      (params["filters"] || %{})
      |> Map.put("1", %{"field" => "search", "value" => text, "op" => "ilike_or"})

    Map.put(params, "filters", filters)
  end

  defp list_offer_times(params) do
    case Companies.list_offer_times(params) do
      {:ok, {offer_times, meta}} ->
        %{offer_times: offer_times, meta: meta}

      {:error, flop} ->
        %{offer_times: [], meta: flop}
    end
  end
end
