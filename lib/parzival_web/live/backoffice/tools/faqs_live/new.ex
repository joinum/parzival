defmodule ParzivalWeb.Backoffice.FaqsLive.New do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Tools.Faq

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :faq)
     |> assign(:page_title, "New Faq")
     |> assign(:faq, %Faq{})}
  end
end
