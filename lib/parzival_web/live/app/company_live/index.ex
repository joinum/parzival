defmodule ParzivalWeb.App.CompanyLive.Index do
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
     |> assign(:current_page, :companies)
     |> assign(:params, params)
     |> assign(list_companies(params))}
  end

  defp list_companies(params) do
    case Companies.list_companies(params) do
      {:ok, {companies, meta}} ->
        %{companies: companies, meta: meta}

      {:error, flop} ->
        %{companies: [], meta: flop}
    end
  end

  @impl true
  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    params = build_search_map(socket.assigns.params, query)

    {:noreply, push_patch(socket, to: Routes.company_index_path(socket, :index, params))}
  end

  defp build_search_map(params, text) do
    filters =
      (params["filters"] || %{})
      |> Map.put("1", %{"field" => "search", "value" => text, "op" => "ilike_or"})

    Map.put(params, "filters", filters)
  end
end
