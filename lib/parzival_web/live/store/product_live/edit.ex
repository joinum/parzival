defmodule ParzivalWeb.ProductLive.Edit do
  use ParzivalWeb, :live_view

  alias Parzival.Store

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :store)
     |> assign(:page_title, "Edit Product")
     |> assign(:product, Store.get_product!(id))}
  end
end
