defmodule ParzivalWeb.App.OfferLive.Edit do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Companies

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :jobs)
     |> assign(:page_title, "Edit Offer")
     |> assign(list_companies(params))
     |> assign(:offer, Companies.get_offer!(id, preloads: [:company, :offer_type, :offer_time]))}
  end

  defp list_companies(params) do
    case Companies.list_companies(params) do
      {:ok, {companies, meta}} ->
        %{companies: companies, meta: meta}

      {:error, flop} ->
        %{companies: [], meta: flop}
    end
  end
end
