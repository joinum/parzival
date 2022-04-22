defmodule ParzivalWeb.PurchasedLive.Index do
  use ParzivalWeb, :live_view

  alias Parzival.Store
  alias Parzival.Store.Prize

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :prizes, list_prizes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
      socket
      |> assign(:current_page, :vault)
      |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Prize")
    |> assign(:prize, Store.get_prize!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Prize")
    |> assign(:prize, %Prize{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Prizes")
    |> assign(:prize, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    prize = Store.get_prize!(id)
    {:ok, _} = Store.delete_prize(prize)

    {:noreply, assign(socket, :prizes, list_prizes())}
  end

  defp list_prizes do
    Store.list_prizes()
  end
end
