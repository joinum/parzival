defmodule ParzivalWeb.App.OfferLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Pagination

  alias Parzival.Companies

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
     |> assign(:page_title, "Listing Offers")
     |> assign(list_offers(params, socket))}
  end

  defp list_offers(params, socket) do
    params =
      params
      |> Map.put("page_size", 7)

    case socket.assigns.current_user.role do
      :recruiter ->
        case Companies.list_offers(
               params,
               preloads: [:company, :offer_type, :offer_time],
               where: [company_id: socket.assigns.current_user.company_id]
             ) do
          {:ok, {offers, meta}} ->
            %{offers: offers, meta: meta}

          {:error, flop} ->
            %{offers: [], meta: flop}
        end

      _ ->
        case Companies.list_offers(
               params,
               preloads: [:company, :offer_type, :offer_time]
             ) do
          {:ok, {offers, meta}} ->
            %{offers: offers, meta: meta}

          {:error, flop} ->
            %{offers: [], meta: flop}
        end
    end
  end

  @impl true
  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    params = build_search_map(socket.assigns.params, query)

    {:noreply, push_patch(socket, to: Routes.offer_index_path(socket, :index, params))}
  end

  defp build_search_map(params, text) do
    filters =
      (params["filters"] || %{})
      |> Map.put("1", %{"field" => "search", "value" => text, "op" => "ilike_or"})

    Map.put(params, "filters", filters)
  end
end
