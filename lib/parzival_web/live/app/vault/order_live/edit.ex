defmodule ParzivalWeb.App.Staff.OrderLive.Edit do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Store
  alias Parzival.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :vault)
     |> assign(:page_title, "Redeem order")
     |> assign(:order, Store.get_order!(id, preloads: [:product, :user]))}
  end
end
