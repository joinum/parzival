defmodule ParzivalWeb.App.LeaderboardLive.Index do
  @moduledoc false

  @page_size 9

  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Pagination

  alias Parzival.Accounts
  alias Parzival.Gamification

  @first_day_start Application.get_env(:parzival, :event)[:first_day_start]
  @first_day_end Application.get_env(:parzival, :event)[:first_day_end]
  @second_day_start Application.get_env(:parzival, :event)[:second_day_start]
  @second_day_end Application.get_env(:parzival, :event)[:second_day_end]
  @third_day_start Application.get_env(:parzival, :event)[:third_day_start]
  @third_day_end Application.get_env(:parzival, :event)[:third_day_end]

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
     |> assign(:current_tab, params["tab"] || "general")
     |> assign(:current_page, :leaderboard)
     |> assign(:params, params)
     |> assign(:current_user, user)
     |> assign(:leaderboard, get_leaderboard(params))
     |> assign(:page_size, @page_size)
     |> assign(:position, get_positions(user))}
  end

  # defp list_offers(params, socket) do
  #   params =
  #     params
  #     |> Map.put("page_size", @page_size)

  #     case params["tab"] do
  #       "general" ->
  #         case Gamification.get_leaderboard(%{}, @first_day_start, @third_day_end) do
  #           {:ok, {applications, meta}} ->
  #             offers =
  #               applications
  #               |> Enum.map(fn application -> application.offer end)

  #             %{offers: offers, meta: meta}

  #           {:error, flop} ->
  #             %{offers: [], meta: flop}
  #         end

  #       _ ->
  #         case Companies.list_offers(
  #                params,
  #                preloads: [:company, :offer_type, :offer_time]
  #              ) do
  #           {:ok, {offers, meta}} ->
  #             %{offers: offers, meta: meta}

  #           {:error, flop} ->
  #             %{offers: [], meta: flop}
  #         end
  #     end
  # end

  defp get_event_days() do
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

  defp get_leaderboard(_params) do
    general = extract_value(Gamification.get_leaderboard(%{}, @first_day_start, @third_day_end))
    one = extract_value(Gamification.get_leaderboard(%{}, @first_day_start, @first_day_end))
    two = extract_value(Gamification.get_leaderboard(%{}, @second_day_start, @second_day_end))
    three = extract_value(Gamification.get_leaderboard(%{}, @third_day_start, @third_day_end))

    %{
      general: general,
      one: one,
      two: two,
      three: three
    }
  end

  defp extract_value({:ok, {data, meta}}) do
    data = Enum.map(data, fn %{experience: exp, user: user} ->
      {Accounts.get_user!(user), exp}
    end)

    %{data: data, meta: meta}
  end

  defp extract_value({:error, flop}) do
    %{data: [], meta: flop}
  end
end
