defmodule ParzivalWeb.OfferLive.FormComponent do
  use ParzivalWeb, :live_component

  alias Parzival.Companies

  @impl true
  def update(%{offer: offer} = assigns, socket) do
    changeset = Companies.change_offer(offer)

    types = Companies.list_offer_types()
    times = Companies.list_offer_times()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:types, types)
     |> assign(:times, times)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"offer" => offer_params}, socket) do
    changeset =
      socket.assigns.offer
      |> Companies.change_offer(offer_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"offer" => offer_params}, socket) do
    save_offer(socket, socket.assigns.action, offer_params)
  end

  defp save_offer(socket, :edit, offer_params) do
    case Companies.update_offer(socket.assigns.offer, offer_params) do
      {:ok, _offer} ->
        {:noreply,
         socket
         |> put_flash(:success, "Offer updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_offer(socket, :new, offer_params) do
    if socket.assigns.current_user.role == :recruiter do
      ^offer_params =
        offer_params
        |> Map.put("company_id", socket.assigns.current_user.company_id)
    end

    case Companies.create_offer(offer_params) do
      {:ok, _offer} ->
        {:noreply,
         socket
         |> put_flash(:success, "Offer created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(changeset: changeset)}
    end
  end
end
