defmodule ParzivalWeb.Backoffice.MissionLive.Edit do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Gamification

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :missions)
     |> assign(:page_title, "Edit Mission")
     |> assign(:mission, Gamification.get_mission!(id, [:tasks, :difficulty]))}
  end
end
