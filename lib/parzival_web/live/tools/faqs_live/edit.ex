defmodule ParzivalWeb.FaqsLive.Edit do
  use ParzivalWeb, :live_view

  alias Parzival.Tools

  @impl true
  def mount(_params, _session, socket) do
      {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
      {:noreply,
          socket
          |> assign(:current_page, :faq)
          |> assign(:page_title, "Edit Faq")
          |> assign(:faq, Tools.get_faq!(id))
      }
  end
end
