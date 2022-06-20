defmodule ParzivalWeb.App.AnnouncementLive.Show do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Accounts
  alias Parzival.Tools

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    user = Accounts.get_user!(socket.assigns.current_user.id)

    case user.role do
      :admin ->
        {:noreply,
         socket
         |> assign(:current_page, :tools)
         |> assign(:page_title, page_title(socket.assigns.live_action))
         |> assign(:announcement, Tools.get_announcement!(id, :author))}

      _ ->
        {:noreply,
         socket
         |> assign(:current_page, :announcements)
         |> assign(:page_title, page_title(socket.assigns.live_action))
         |> assign(:announcement, Tools.get_announcement!(id, :author))}
    end
  end

  @impl true
  def handle_event("delete", _args, socket) do
    {:ok, _} = Tools.delete_announcement(socket.assigns.announcement)

    {:noreply,
     socket
     |> put_flash(:info, "Announcement deleted successfully!")
     |> push_redirect(to: Routes.announcement_index_path(socket, :index))}
  end

  defp page_title(:show), do: "Show Announcement"
  defp page_title(:edit), do: "Edit Announcement"
end
