defmodule ParzivalWeb.HomeLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Tools

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:announcements, Enum.take(Tools.list_announcements(), 3))
     |> assign(:current_page, :home)}
  end
end
