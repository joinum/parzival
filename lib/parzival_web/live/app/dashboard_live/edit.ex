defmodule ParzivalWeb.App.DashboardLive.Edit do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Accounts
  alias Parzival.Gamification
  alias Parzival.Tools

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    user = Accounts.get_user!(socket.assigns.current_user.id, [:company, :curriculum])

    {:noreply,
     socket
     |> assign(:current_page, :dashboard)
     |> assign(:page_title, "Dashboard")
     |> assign(:announcements, list_announcements())
     |> assign(:user, user)
     |> assign(:curriculum, Gamification.get_user_curriculum(user, []))
     |> assign(list_top_users(params))}
  end

  defp list_announcements do
    Tools.list_announcements(preloads: [:author], limit: 3, order_by: [desc: :inserted_at])
  end

  defp list_top_users(params) do
    params =
      params
      |> Map.put("page_size", 3)

    case Accounts.list_users(
           params,
           where: [role: :attendee],
           order_by: [desc: :exp]
         ) do
      {:ok, {users, _}} ->
        %{users: users}

      {:error, _} ->
        %{users: []}
    end
  end
end
