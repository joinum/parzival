defmodule ParzivalWeb.Backoffice.BoostLive.New do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Store.Boost

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :store)
     |> assign(:page_title, "New Boost")
     |> assign(:boost, %Boost{})}
  end
end
