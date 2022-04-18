defmodule ParzivalWeb.FaqsLive.Index do
  use ParzivalWeb, :live_view

  alias Parzival.Tools
  alias Parzival.Tools.Faq

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :faqs, list_faqs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
      socket
      |> assign(:current_page, :tools)
      |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Faq")
    |> assign(:faq, Tools.get_faq!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Faq")
    |> assign(:faq, %Faq{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Faqs")
    |> assign(:faq, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    faq = Tools.get_faq!(id)
    {:ok, _} = Tools.delete_faq(faq)

    {:noreply, assign(socket, :faqs_collection, list_faqs())}
  end

  defp list_faqs do
    Tools.list_faqs()
  end
end
