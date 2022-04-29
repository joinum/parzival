defmodule ParzivalWeb.OrderLive.Index do
  use ParzivalWeb, :live_view

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
      |> assign(:orders, list_orders(socket.assigns.current_user))
      |> assign(:current_page, :vault)}
  end

  defp list_orders(current_user) do
    Store.list_orders_by_user(current_user, [preloads: [:product]])
  end
end
