defmodule ParzivalWeb.AnnouncementLive.New do
  use ParzivalWeb, :live_view

  alias Parzival.Tools.Announcement

  @impl true
  def mount(_params, _session, socket) do
      {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
      {:noreply,
          socket
          |> assign(:current_page, :announcement)
          |> assign(:page_title, "New Announcement")
          |> assign(:announcement, %Announcement{})
      }
  end
end
