defmodule ParzivalWeb.App.LeaderboardLive.Index do
  @moduledoc false

  @page_size 10

  use ParzivalWeb, :live_view

  alias Parzival.Accounts
  alias Parzival.Gamification
  alias Parzival.Tools.EventDays
  # alias ParzivalWeb.ViewUtils

  @first_day_start EventDays.get_first_day_start()
  @first_day_end EventDays.get_first_day_end()
  @second_day_start EventDays.get_second_day_start()
  @second_day_end EventDays.get_second_day_end()
  @third_day_start EventDays.get_third_day_start()
  @third_day_end EventDays.get_third_day_end()

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    user = Accounts.get_user!(socket.assigns.current_user.id, [:missions])

    {:noreply,
     socket
     |> assign(:event_days, get_event_days())
     |> assign(
       :current_page,
       if user.role == :attendee do
         :leaderboard
       else
         :missions
       end
     )
     |> assign(:params, params)
     |> assign(:current_user, user)
     |> assign(:leaderboard, get_leaderboard())
     |> assign(:page_size, @page_size)
     |> assign(:position, get_positions(user))}
  end

  defp get_event_days do
    %{
      first_day_start: @first_day_start,
      first_day_end: @first_day_end,
      second_day_start: @second_day_start,
      second_day_end: @second_day_end,
      third_day_start: @third_day_start,
      third_day_end: @third_day_end
    }
  end

  defp get_positions(user) do
    general = Gamification.get_user_position_general(user)
    one = Gamification.get_user_position_by_day(user, @first_day_start, @first_day_end)
    two = Gamification.get_user_position_by_day(user, @second_day_start, @second_day_end)
    three = Gamification.get_user_position_by_day(user, @third_day_start, @third_day_end)

    %{
      general: general,
      one: one,
      two: two,
      three: three
    }
  end

  defp get_leaderboard do
    general = extract_value(Gamification.get_leaderboard(@first_day_start, @third_day_end))

    one = extract_value(Gamification.get_leaderboard(@first_day_start, @first_day_end))

    two = extract_value(Gamification.get_leaderboard(@second_day_start, @second_day_end))

    three = extract_value(Gamification.get_leaderboard(@third_day_start, @third_day_end))

    %{
      general: general,
      one: one,
      two: two,
      three: three
    }
  end

  defp extract_value(data) do
    Enum.map(data, fn %{experience: exp, user: user} ->
      {Accounts.get_user!(user), exp}
    end)
  end
end
