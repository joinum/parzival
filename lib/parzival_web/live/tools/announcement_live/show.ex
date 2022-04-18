defmodule ParzivalWeb.AnnouncementLive.Show do
  use ParzivalWeb, :live_view

  alias Parzival.Tools

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :tools)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:announcement, Tools.get_announcement!(id))}
  end

  defp page_title(:show), do: "Show Announcement"
  defp page_title(:edit), do: "Edit Announcement"
end
