defmodule ParzivalWeb.Backoffice.MissionLive.New do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Gamification.Mission
  alias Parzival.Gamification.Mission.Task

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :missions)
     |> assign(:page_title, "New Mission")
     |> assign(:mission, %Mission{tasks: [%Task{}]})}
  end
end
