defmodule ParzivalWeb.App.OrderLive.FormComponent do
  @moduledoc false
  use ParzivalWeb, :live_component

  alias Parzival.Store

  @impl true
  def update(%{order: order} = assigns, socket) do
    changeset = Store.change_order(order)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"order" => order_params}, socket) do
    save_order(socket, order_params)
  end

  defp save_order(socket, order_params) do
    case Store.update_order(socket.assigns.order, order_params) do
      {:ok, _order} ->
        {:noreply,
         socket
         |> put_flash(:success, "Order delivered successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
