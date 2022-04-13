defmodule ParzivalWeb.FaqsLive.FormComponent do
  use ParzivalWeb, :live_component

  alias Parzival.Tools

  @impl true
  def update(%{faqs: faqs} = assigns, socket) do
    changeset = Tools.change_faqs(faqs)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"faqs" => faqs_params}, socket) do
    changeset =
      socket.assigns.faqs
      |> Tools.change_faqs(faqs_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"faqs" => faqs_params}, socket) do
    save_faqs(socket, socket.assigns.action, faqs_params)
  end

  defp save_faqs(socket, :edit, faqs_params) do
    case Tools.update_faqs(socket.assigns.faqs, faqs_params) do
      {:ok, _faqs} ->
        {:noreply,
         socket
         |> put_flash(:info, "Faqs updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_faqs(socket, :new, faqs_params) do
    case Tools.create_faqs(faqs_params) do
      {:ok, _faqs} ->
        {:noreply,
         socket
         |> put_flash(:info, "Faqs created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
