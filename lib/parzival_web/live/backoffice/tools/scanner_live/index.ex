defmodule ParzivalWeb.Backoffice.ScannerLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :scanner)
     |> assign(:page_title, "Scan QR")}
  end

  def handle_event("scan", pathname, socket) do
    {:noreply, push_redirect(socket, to: "/#{pathname}")}
  end
end
