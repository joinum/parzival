defmodule ParzivalWeb.Backoffice.DifficultyLive.FormComponent do
  @moduledoc false
  use ParzivalWeb, :live_component

  import ParzivalWeb.Components.Buttons

  alias Parzival.Gamification

  @impl true
  def update(%{difficulty: difficulty} = assigns, socket) do
    changeset = Gamification.change_difficulty(difficulty)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"difficulty" => difficulty_params}, socket) do
    changeset =
      socket.assigns.difficulty
      |> Gamification.change_difficulty(difficulty_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"difficulty" => difficulty_params}, socket) do
    save_difficulty(socket, socket.assigns.action, difficulty_params)
  end

  defp save_difficulty(socket, :edit, difficulty_params) do
    case Gamification.update_difficulty(socket.assigns.difficulty, difficulty_params) do
      {:ok, _difficulty} ->
        {:noreply,
         socket
         |> put_flash(:success, "Difficulty updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_difficulty(socket, :new, difficulty_params) do
    case Gamification.create_difficulty(difficulty_params) do
      {:ok, _difficulty} ->
        {:noreply,
         socket
         |> put_flash(:success, "Difficulty created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
