defmodule ParzivalWeb.App.ProductLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Pagination

  alias Parzival.Store
  alias Parzival.Uploaders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :store)
     |> assign(:page_title, "Store")
     |> assign(:params, params)
     |> assign(list_products(params))}
  end

  defp list_products(params) do
    case Store.list_products(params) do
      {:ok, {products, meta}} ->
        %{products: products, meta: meta}

      {:error, flop} ->
        %{products: [], meta: flop}
    end
  end
end
