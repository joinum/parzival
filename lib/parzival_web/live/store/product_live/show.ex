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
     |> assign(:redeem_quantity, redeem_quantity(socket.assigns.current_user.id, id))
     |> assign(:product, Store.get_product!(id))}
  end

  def redeem_quantity(user_id, product_id) do
    order = Store.get_order_by_user_and_product(user_id, product_id)
    case order do
      nil ->  Store.get_product!(product_id).max_per_user
      _ ->  Store.get_product!(product_id).max_per_user - order.quantity
    end

  end

  @impl true
  def handle_event("delete", _payload, socket) do
    {:ok, _} = Store.delete_product(socket.assigns.product)
    {:noreply, push_redirect(socket, to: Routes.product_index_path(socket, :index))}
  end

  @impl true
  def handle_event("purchase", _payload, socket) do

    product = socket.assigns.product
    current_user = socket.assigns.current_user

    case Store.purchase(current_user, product) do
      {:ok, _order} ->
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"
end
