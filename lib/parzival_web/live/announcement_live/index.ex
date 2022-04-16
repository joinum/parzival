defmodule ParzivalWeb.AnnouncementLive.Index do
  use ParzivalWeb, :live_view

  alias Parzival.Tools
  alias Parzival.Tools.Announcement

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :announcements, list_announcements())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
      socket
      |> assign(:current_page, :announcements)
      |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Announcement")
    |> assign(:announcement, Tools.get_announcement!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Announcement")
    |> assign(:announcement, %Announcement{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Announcements")
    |> assign(:announcement, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    announcement = Tools.get_announcement!(id)
    {:ok, _} = Tools.delete_announcement(announcement)

    {:noreply, assign(socket, :announcements, list_announcements())}
  end

  defp list_announcements do
    Tools.list_announcements()
  end
end
