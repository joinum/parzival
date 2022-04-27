defmodule ParzivalWeb.EarnedLive.Index do
  use ParzivalWeb, :live_view

  alias Parzival.Store
  alias Parzival.Store.Order

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :orders, list_orders())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
      socket
      |> assign(:current_page, :vault)
      |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Order")
    |> assign(:order, Store.get_order!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Order")
    |> assign(:order, %Order{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Orders")
    |> assign(:order, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    order = Store.get_order!(id)
    {:ok, _} = Store.delete_order(order)

    {:noreply, assign(socket, :orders, list_orders())}
  end

  defp list_orders do
    Store.list_orders()
  end
end
