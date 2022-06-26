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
     |> assign(:order, Store.get_order!(id, preloads: [:product]))
     |> assign(:qrcode, qr_code(socket, id))}
  end

  defp qr_code(socket, id) do
    Routes.admin_order_edit_url(socket, :edit, id)
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(color: "#1F2937", width: 295, background_color: :transparent)
  end
end
