defmodule ParzivalWeb.App.OrderLive.Show do
  @moduledoc false
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
     |> assign(:current_page, :vault)
     |> assign(:page_title, "Show order")
     |> assign(:order, Store.get_order!(id, preloads: [:product]))}
  end
end
