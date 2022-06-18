defmodule ParzivalWeb.App.LeaderboardLive.Index do
  @moduledoc false

  @page_size 8

  use ParzivalWeb, :live_view

  alias Parzival.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    user = Accounts.get_user!(socket.assigns.current_user.id, [:missions, inventory: [:boost]])

    {:noreply,
     socket
     |> assign(:current_page, :leaderboard)
     |> assign(:params, params)
     |> assign(:current_user, user)
     |> assign(list_users(params))
     |> assign(:page_size, @page_size)
     |> assign(:position, Accounts.get_user_position(user))}
  end

  defp list_users(params) do
    params =
      params
      |> Map.put("page_size", @page_size)

    case Accounts.list_users(params,
           where: [role: :attendee],
           order_by: [desc: :exp]
         ) do
      {:ok, {users, meta}} ->
        %{users: users, meta: meta}

      {:error, flop} ->
        %{users: [], meta: flop}
    end
  end
end
