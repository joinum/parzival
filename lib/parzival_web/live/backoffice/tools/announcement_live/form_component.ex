defmodule ParzivalWeb.Backoffice.AnnouncementLive.FormComponent do
  @moduledoc false
  use ParzivalWeb, :live_component

  alias Parzival.Tools

  @impl true
  def update(%{announcement: announcement} = assigns, socket) do
    changeset = Tools.change_announcement(announcement)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"announcement" => announcement_params}, socket) do
    changeset =
      socket.assigns.announcement
      |> Tools.change_announcement(announcement_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"announcement" => announcement_params}, socket) do
    announcement_params =
      announcement_params
      |> Map.put("author_id", socket.assigns.current_user.id)

    save_announcement(socket, socket.assigns.action, announcement_params)
  end

  defp save_announcement(socket, :edit, announcement_params) do
    case Tools.update_announcement(socket.assigns.announcement, announcement_params) do
      {:ok, _announcement} ->
        {:noreply,
         socket
         |> put_flash(:info, "Announcement updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_announcement(socket, :new, announcement_params) do
    case Tools.create_announcement(announcement_params) do
      {:ok, _announcement} ->
        {:noreply,
         socket
         |> put_flash(:info, "Announcement created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
