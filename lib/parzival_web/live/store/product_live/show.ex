defmodule ParzivalWeb.ProductLive.Show do
  use ParzivalWeb, :live_view

  alias Parzival.Store
  alias Parzival.Uploaders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :store)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, Store.get_product!(id))}
  end

  @impl true
  def handle_event("delete", _payload, socket) do
    {:ok, _} = Store.delete_product(socket.assigns.product)
    {:noreply, push_redirect(socket, to: Routes.product_index_path(socket, :index))}
  end



  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"
end
