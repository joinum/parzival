defmodule ParzivalWeb.Backoffice.LevelLive.FormComponent do
  @moduledoc false
  use ParzivalWeb, :live_component

  import ParzivalWeb.Components.Buttons

  alias Parzival.Companies

  @impl true
  def update(%{level: level} = assigns, socket) do
    changeset = Companies.change_level(level)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"level" => level_params}, socket) do
    changeset =
      socket.assigns.level
      |> Companies.change_level(level_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"level" => level_params}, socket) do
    save_level(socket, socket.assigns.action, level_params)
  end

  defp save_level(socket, :edit, level_params) do
    case Companies.update_level(socket.assigns.level, level_params) do
      {:ok, _level} ->
        {:noreply,
         socket
         |> put_flash(:info, "Level updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_level(socket, :new, level_params) do
    case Companies.create_level(level_params) do
      {:ok, _level} ->
        {:noreply,
         socket
         |> put_flash(:info, "Level created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
