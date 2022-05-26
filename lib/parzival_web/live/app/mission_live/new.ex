defmodule ParzivalWeb.App.MissionLive.New do
  @moduledoc false
  use ParzivalWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end
end
