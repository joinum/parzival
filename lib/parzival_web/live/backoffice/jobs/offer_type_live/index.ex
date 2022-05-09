defmodule ParzivalWeb.Backoffice.OfferTypeLive.Index do
  use ParzivalWeb, :live_view

  alias Parzival.Companies
  alias Parzival.Companies.OfferType

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :offer_types, list_offer_types())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
      socket
      |> assign(:current_page, :jobs)
      |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Offer type")
    |> assign(:offer_type, Companies.get_offer_type!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Offer type")
    |> assign(:offer_type, %OfferType{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Offer types")
    |> assign(:offer_type, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    offer_type = Companies.get_offer_type!(id)
    {:ok, _} = Companies.delete_offer_type(offer_type)

    {:noreply, assign(socket, :offer_types, list_offer_types())}
  end

  defp list_offer_types do
    Companies.list_offer_types()
  end
end
