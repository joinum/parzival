defmodule ParzivalWeb.Backoffice.FaqsLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Pagination

  alias Parzival.Tools
  alias Parzival.Tools.Faq

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, list_faqs(params))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :tools)
     |> assign(:params, params)
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

  defp list_faqs(params) do
    case Tools.list_faqs(params) do
      {:ok, {faqs, meta}} ->
        %{faqs: faqs, meta: meta}

      {:error, flop} ->
        %{faqs: [], meta: flop}
    end
  end
end
