defmodule ParzivalWeb.App.LeaderboardLive.Index do
  @moduledoc false

  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Pagination

  alias Parzival.Accounts

  @impl true
  def mount(params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :leaderboard)
     |> assign(:params, params)
     |> assign(list_users(params))}
  end

  defp list_users(params) do
    params =
      params
      |> Map.put("page_size", 8)

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
