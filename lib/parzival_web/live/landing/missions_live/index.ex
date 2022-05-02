defmodule ParzivalWeb.Landing.MissionsLive.Index do
  @moduledoc false
  use ParzivalWeb, [:live_view, {ParzivalWeb.LayoutView, "landing.html"}]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:current_page, "Missions")}
  end
end
