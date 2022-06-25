defmodule ParzivalWeb.App.BoostLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Pagination

  alias Parzival.Store
  alias Parzival.Uploaders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :store)
     |> assign(:page_title, "Store")
     |> assign(:params, params)
     |> assign(list_boosts(params))}
  end

  defp list_boosts(params) do
    case Store.list_boosts(params) do
      {:ok, {boosts, meta}} ->
        %{boosts: boosts, meta: meta}

      {:error, flop} ->
        %{boosts: [], meta: flop}
    end
  end
end
