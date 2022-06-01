defmodule ParzivalWeb.Backoffice.DificultyLive.FormComponent do
  @moduledoc false
  use ParzivalWeb, :live_component

  import ParzivalWeb.Components.Buttons

  alias Parzival.Gamification

  @impl true
  def update(%{dificulty: dificulty} = assigns, socket) do
    changeset = Gamification.change_dificulty(dificulty)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"dificulty" => dificulty_params}, socket) do
    changeset =
      socket.assigns.dificulty
      |> Gamification.change_dificulty(dificulty_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"dificulty" => dificulty_params}, socket) do
    save_dificulty(socket, socket.assigns.action, dificulty_params)
  end

  defp save_dificulty(socket, :edit, dificulty_params) do
    case Gamification.update_dificulty(socket.assigns.dificulty, dificulty_params) do
      {:ok, _dificulty} ->
        {:noreply,
         socket
         |> put_flash(:success, "Dificulty updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_dificulty(socket, :new, dificulty_params) do
    case Gamification.create_dificulty(dificulty_params) do
      {:ok, _dificulty} ->
        {:noreply,
         socket
         |> put_flash(:success, "Dificulty created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
