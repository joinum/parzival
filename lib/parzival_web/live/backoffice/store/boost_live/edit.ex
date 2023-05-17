defmodule ParzivalWeb.Backoffice.BoostLive.Edit do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Store

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :store)
     |> assign(:page_title, "Edit Boost")
     |> assign(:boost, Store.get_boost!(id))}
  end
end
