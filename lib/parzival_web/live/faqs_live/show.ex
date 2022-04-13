defmodule ParzivalWeb.FaqsLive.Show do
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
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:faqs, Tools.get_faqs!(id))}
  end

  defp page_title(:show), do: "Show Faqs"
  defp page_title(:edit), do: "Edit Faqs"
end
