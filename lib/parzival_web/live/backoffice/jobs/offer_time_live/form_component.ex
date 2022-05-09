defmodule ParzivalWeb.OfferTimeLive.FormComponent do
  use ParzivalWeb, :live_component

  alias Parzival.Companies

  @impl true
  def update(%{offer_time: offer_time} = assigns, socket) do
    changeset = Companies.change_offer_time(offer_time)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"offer_time" => offer_time_params}, socket) do
    changeset =
      socket.assigns.offer_time
      |> Companies.change_offer_time(offer_time_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"offer_time" => offer_time_params}, socket) do
    save_offer_time(socket, socket.assigns.action, offer_time_params)
  end

  defp save_offer_time(socket, :edit, offer_time_params) do
    case Companies.update_offer_time(socket.assigns.offer_time, offer_time_params) do
      {:ok, _offer_time} ->
        {:noreply,
         socket
         |> put_flash(:info, "Offer time updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_offer_time(socket, :new, offer_time_params) do
    case Companies.create_offer_time(offer_time_params) do
      {:ok, _offer_time} ->
        {:noreply,
         socket
         |> put_flash(:info, "Offer time created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
