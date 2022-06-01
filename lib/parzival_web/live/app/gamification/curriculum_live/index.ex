defmodule ParzivalWeb.App.CurriculumLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Gamification

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :curriculum)
     |> assign(
       :curriculum,
       Gamification.get_curriculum!(socket.assigns.current_user.curriculum_id)
     )}
  end
end
