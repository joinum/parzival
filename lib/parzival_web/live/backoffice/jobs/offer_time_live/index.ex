defmodule ParzivalWeb.Backoffice.OfferTimeLive.Index do
  use ParzivalWeb, :live_view

  alias Parzival.Companies
  alias Parzival.Companies.OfferTime

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :offer_times, list_offer_times())}
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
    |> assign(:page_title, "Edit Offer time")
    |> assign(:offer_time, Companies.get_offer_time!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Offer time")
    |> assign(:offer_time, %OfferTime{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Offer times")
    |> assign(:offer_time, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    offer_time = Companies.get_offer_time!(id)
    {:ok, _} = Companies.delete_offer_time(offer_time)

    {:noreply, assign(socket, :offer_times, list_offer_times())}
  end

  defp list_offer_times do
    Companies.list_offer_times()
  end
end
