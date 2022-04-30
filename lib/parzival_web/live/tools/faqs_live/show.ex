defmodule ParzivalWeb.FaqsLive.Show do
  @moduledoc false
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
     |> assign(:current_page, :tools)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:faq, Tools.get_faq!(id))}
  end

  @impl true
  def handle_event("delete", _args, socket) do
    {:ok, _} = Tools.delete_faq(socket.assigns.faq)

    {:noreply,
     socket
     |> put_flash(:info, gettext("Faq deleted successfully!"))
     |> push_redirect(to: Routes.faqs_index_path(socket, :index))}
  end

  defp page_title(:show), do: "Show Faqs"
  defp page_title(:edit), do: "Edit Faqs"
end
