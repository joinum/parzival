defmodule ParzivalWeb.App.OfferLive.New do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Companies
  alias Parzival.Companies.Offer

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :jobs)
     |> assign(:page_title, "New Offer")
     |> assign(list_companies(params))
     |> assign(:offer, %Offer{})}
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
