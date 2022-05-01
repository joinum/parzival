defmodule ParzivalWeb.AnnouncementLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Tools

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :tools)
     |> assign(:announcements, list_announcements())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    announcement = Tools.get_announcement!(id)
    {:ok, _} = Tools.delete_announcement(announcement)

    {:noreply, assign(socket, :announcements, list_announcements())}
  end

  defp list_announcements do
    Tools.list_announcements(preloads: [:author], order_by: [desc: :inserted_at])
  end
end
