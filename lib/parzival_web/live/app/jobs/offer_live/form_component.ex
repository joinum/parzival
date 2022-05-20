defmodule ParzivalWeb.OfferLive.FormComponent do
  use ParzivalWeb, :live_component

  alias Parzival.Companies

  @impl true
  def update(%{offer: offer} = assigns, socket) do
    changeset = Companies.change_offer(offer)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(list_offer_types())
     |> assign(list_offer_times())}
  end

  defp list_offer_types() do
    case Companies.list_offer_types() do
      {:ok, {offer_types, _meta}} ->
        %{offer_types: offer_types}

      {:error, _flop} ->
        %{offer_types: []}
    end
  end

  defp list_offer_times() do
    case Companies.list_offer_times() do
      {:ok, {offer_times, _meta}} ->
        %{offer_times: offer_times}

      {:error, _flop} ->
        %{offer_times: []}
    end
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
    offer_params =
      if socket.assigns.current_user.role == :recruiter do
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
