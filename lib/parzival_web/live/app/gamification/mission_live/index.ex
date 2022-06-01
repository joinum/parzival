defmodule ParzivalWeb.App.MissionLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Accounts
  alias Parzival.Gamification

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    missions_levels =
      Gamification.list_missions(preloads: [:dificulty, tasks: [:users]])
      |> Enum.group_by(& &1.level)

    current_user = Accounts.get_user!(socket.assigns.current_user.id)

    user_lvl = Gamification.calc_level(current_user.exp)

    {:noreply,
     socket
     |> assign(:current_page, :missions)
     |> assign(:missions_levels, missions_levels)
     |> assign(:user_lvl, user_lvl)}
  end

  def mission_list_entry(assigns) do
    ~H"""
    <li id={"mission-#{assigns.mission.title}"} class={"relative px-6 border-b border-gray-200 #{if assigns.mission.level <= assigns.user_lvl || assigns.current_user.role in [:admin, :staff] do
          "cursor-pointer hover:bg-gray-50"
        end}"}>
      <div class={"flex flex-col justify-between lg:flex-row #{if assigns.mission.level > assigns.user_lvl && assigns.current_user.role in [:attendee] do
          "opacity-40"
        end}"}>
        <div class="pt-4 text-sm lg:py-4">
          <div class="flex items-center">
            <div class="ml-0 sm:ml-2">
              <span class="font-medium text-gray-900">
                <%= assigns.mission.title %>
              </span>
              <div class="mt-3 text-gray-500">
                <div class="flex flex-row gap-x-5">
                  <div class="flex text-right text-gray-500 lg:hidden lg:pl-0 items-centertext-xs">
                    <span class={"inline-flex items-center justify-center px-2 text-xs font-semibold leading-5 border #{border_200(@mission.dificulty.color)} #{bg_100(@mission.dificulty.color)} rounded-full"}>
                      <%= assigns.mission.dificulty.name %>
                    </span>
                  </div>
                  <div class="flex flex-row gap-x-1 text-sm">
                    <Heroicons.Solid.clipboard_list class="w-[18px] h-[18px]" />
                    <%= if assigns.current_user.role in [:attendee] do %>
                      <%= Enum.reduce(assigns.mission.tasks, 0, fn x, acc ->
                        if(Enum.any?(x.users, &(&1.id == assigns.current_user.id)) == true) do
                          acc + 1
                        else
                          acc
                        end
                      end) %> /
                    <% end %>
                    <%= Enum.count(assigns.mission.tasks) %>
                  </div>
                  <span class="text-sm">💰 <%= assigns.mission.tokens %></span>
                  <div class="text-sm text-right text-gray-500 lg:hidden">
                    <%= assigns.mission.exp %> EXP
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="flex flex-row pb-2 mt-2 w-full lg:flex-col lg:justify-between lg:pt-2 lg:pb-0 lg:mt-0 lg:w-auto">
          <div class="hidden flex-shrink-0 justify-end lg:flex lg:ml-2">
            <p class={"inline-flex items-center justify-center px-2 text-xs font-semibold leading-5 #{border_200(@mission.dificulty.color)} #{bg_100(@mission.dificulty.color)} border rounded-full"}>
              <%= assigns.mission.dificulty.name %>
            </p>
          </div>
          <div class="hidden items-center px-2 ml-5 text-xs text-right text-gray-500 lg:flex lg:pb-1 lg:pl-0">
            <%= assigns.mission.exp %> EXP
          </div>
        </div>
      </div>
    </li>
    """
  end
end
