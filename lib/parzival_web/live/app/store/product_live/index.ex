defmodule ParzivalWeb.App.ProductLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Store
  alias Parzival.Store.Product
  alias Parzival.Uploaders

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, list_products(params))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :store)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Store.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
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
