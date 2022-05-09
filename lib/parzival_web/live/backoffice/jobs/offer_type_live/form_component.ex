defmodule ParzivalWeb.Backoffice.OfferTypeLive.FormComponent do
  use ParzivalWeb, :live_component

  import ParzivalWeb.Components.Buttons

  alias Parzival.Companies

  @impl true
  def update(%{offer_type: offer_type} = assigns, socket) do
    changeset = Companies.change_offer_type(offer_type)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"offer_type" => offer_type_params}, socket) do
    changeset =
      socket.assigns.offer_type
      |> Companies.change_offer_type(offer_type_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"offer_type" => offer_type_params}, socket) do
    save_offer_type(socket, socket.assigns.action, offer_type_params)
  end

  defp save_offer_type(socket, :edit, offer_type_params) do
    case Companies.update_offer_type(socket.assigns.offer_type, offer_type_params) do
      {:ok, _offer_type} ->
        {:noreply,
         socket
         |> put_flash(:success, "Type updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_offer_type(socket, :new, offer_type_params) do
    case Companies.create_offer_type(offer_type_params) do
      {:ok, _offer_type} ->
        {:noreply,
         socket
         |> put_flash(:success, "Type created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
