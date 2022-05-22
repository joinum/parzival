defmodule ParzivalWeb.App.DashboardLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Accounts
  alias Parzival.Tools

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    user = Accounts.get_user!(socket.assigns.current_user.id)

    {:noreply,
     socket
     |> assign(:current_page, :home)
     |> assign(:announcements, list_announcements())
     |> assign(:user, user)}
  end

  defp list_announcements do
    Tools.list_announcements(preloads: [:author], limit: 3, order_by: [desc: :inserted_at])
  end
end
