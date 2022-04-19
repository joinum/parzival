defmodule ParzivalWeb.HomeLive.Index do
  use ParzivalWeb, :live_view

  alias Parzival.Tools
  alias Parzival.Tools.Announcement

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:announcements, Enum.take(Tools.list_announcements(), 3))
     |> assign(:current_page, :home)}
  end

end
