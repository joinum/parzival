defmodule ParzivalWeb.HomeLive.Index do
  use ParzivalWeb, :live_view


  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, socket}
  end

end
