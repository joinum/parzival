defmodule ParzivalWeb.OfferTypeLive.Show do
  use ParzivalWeb, :live_view

  alias Parzival.Companies

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:offer_type, Companies.get_offer_type!(id))}
  end

  defp page_title(:show), do: "Show Offer type"
  defp page_title(:edit), do: "Edit Offer type"
end
