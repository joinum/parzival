defmodule ParzivalWeb.App.OfferLive.Show do
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
     |> assign(:current_page, :jobs)
     |> assign(:page_title, "Show Offer")
     |> assign(:offer, Companies.get_offer!(id, preloads: [:company, :offer_type, :offer_time]))}
  end
end
