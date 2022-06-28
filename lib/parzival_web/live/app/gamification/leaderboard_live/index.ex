defmodule ParzivalWeb.App.LeaderboardLive.Index do
  @moduledoc false

  @page_size 8

  use ParzivalWeb, :live_view

  alias Parzival.Accounts
  alias Parzival.Gamification

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    user = Accounts.get_user!(socket.assigns.current_user.id, [:missions])

    {:noreply,
     socket
     |> assign(:current_page, :leaderboard)
     |> assign(:params, params)
     |> assign(:current_user, user)
     |> assign(:leaderboard, get_leaderboard(params))
     |> assign(:page_size, @page_size)
     |> assign(:position, get_positions(user))}
  end

  defp get_positions(user) do
    general = Gamification.get_user_position(user, 0)
    one = Gamification.get_user_position(user, 1)
    two = Gamification.get_user_position(user, 2)
    three = Gamification.get_user_position(user, 3)

    %{
      general: general,
      one: one,
      two: two,
      three: three
    }
  end

  defp get_leaderboard(params) do
    params =
      params
      |> Map.put("page_size", @page_size)

    general = extract_value(Gamification.get_leaderboard(params, 0, @page_size))
    one = extract_value(Gamification.get_leaderboard(params, 1, @page_size))
    two = extract_value(Gamification.get_leaderboard(params, 2, @page_size))
    three = extract_value(Gamification.get_leaderboard(params, 3, @page_size))

    %{
      general: general,
      one: one,
      two: two,
      three: three
    }
  end

  defp extract_value(data) do
    case data do
      {:ok, {value, _meta}} -> value
      _ -> []
    end
  end

  defp list_users(params) do
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
