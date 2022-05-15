defmodule ParzivalWeb.App.AnnouncementLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Pagination

  alias Parzival.Tools

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, list_announcements(params))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :tools)
     |> assign(:params, params)
     |> assign(list_announcements(params))}
  end

  defp list_announcements(params) do
    case Tools.list_announcements(params, preloads: [:author]) do
      {:ok, {announcements, meta}} ->
        %{announcements: announcements, meta: meta}

      {:error, flop} ->
        %{announcements: [], meta: flop}
    end
  end
end
