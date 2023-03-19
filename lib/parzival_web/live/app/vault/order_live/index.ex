defmodule ParzivalWeb.App.OrderLive.Index do
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
     |> assign(:current_page, :vault)
     |> assign(:params, params)
     |> assign(list_products(params))
     |> assign(list_orders(params, socket))}
  end

  defp list_products(params) do
    case Store.list_products(params, limit: 2) do
      {:ok, {products, meta}} ->
        %{products: products, meta: meta}

      {:error, flop} ->
        %{products: [], meta: flop}
    end
  end

  defp list_orders(params, socket) do
    params =
      params
      |> Map.put("page_size", 6)

    case Store.list_orders(params,
           where: [user_id: socket.assigns.current_user.id],
           preloads: [:product]
         ) do
      {:ok, {orders, meta}} ->
        %{orders: orders, meta: meta}

      {:error, flop} ->
        %{orders: [], meta: flop}
    end
  end
end
