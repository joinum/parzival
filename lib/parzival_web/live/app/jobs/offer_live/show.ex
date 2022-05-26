defmodule ParzivalWeb.App.OfferLive.Show do
  @moduledoc false
  use ParzivalWeb, :live_view

  require Logger

  import ParzivalWeb.Components.Pagination

  alias Parzival.Companies

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Companies.subscribe("new_application")
      Companies.subscribe("deleted_application")
    end

    {:ok, assign(socket, :id, id)}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    offer = Companies.get_offer!(id, preloads: [:company, :offer_type, :offer_time])

    {:noreply,
     socket
     |> assign(:current_page, :jobs)
     |> assign(:page_title, "Show Offer")
     |> assign(:params, params)
     |> assign(:applied?, Companies.is_user_applied?(offer, socket.assigns.current_user))
     |> assign(:offer, %{offer | applied: Companies.get_total_applied(offer)})
     |> assign(list_applications(params, offer.id))}
  end

  defp list_applications(params, offer_id) do
    case Companies.list_applications(params, where: [offer_id: offer_id], preloads: [:user]) do
      {:ok, {applications, meta}} ->
        %{applications: applications, meta: meta}

      {:error, flop} ->
        %{applications: [], meta: flop}
    end
  end

  @impl true
  def handle_event("apply", _payload, socket) do
    offer = socket.assigns.offer
    current_user = socket.assigns.current_user

    case Companies.create_offer_application(offer, current_user) do
      {:ok, _enrollment} ->
        {:noreply,
         socket
         |> put_flash(:success, gettext("Applied successufully!"))
         |> set_applied(offer, current_user)}

      {:error, error} ->
        Logger.error(error)

        {:noreply,
         socket
         |> put_flash(:error, gettext("Unable to apply"))
         |> set_applied(offer, current_user)}
    end
  end

  @impl true
  def handle_event("unapply", _payload, socket) do
    offer = socket.assigns.offer
    current_user = socket.assigns.current_user

    case Companies.delete_offer_application(offer, current_user) do
      {1, nil} ->
        {:noreply,
         socket
         |> put_flash(:success, gettext("Unapplied successufully!"))
         |> set_applied(offer, current_user)}

      {_, nil} ->
        {:noreply,
         socket
         |> set_applied(offer, current_user)}
    end
  end

  @impl true
  def handle_info({event, application}, socket) when event in [:new_application] do
    offer = socket.assigns.offer

    if offer.id == application.offer_id do
      {:noreply, assign(socket, :offer, %{offer | applied: Companies.get_total_applied(offer)})}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({event, _application}, socket) when event in [:deleted_application] do
    offer = socket.assigns.offer

    {:noreply, assign(socket, :offer, %{offer | applied: Companies.get_total_applied(offer)})}
  end

  defp set_applied(socket, offer, current_user) do
    socket
    |> assign(:applied?, Companies.is_user_applied?(offer, current_user))
  end
end
