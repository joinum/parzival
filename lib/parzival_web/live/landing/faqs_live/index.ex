defmodule ParzivalWeb.Landing.FaqsLive.Index do
  @moduledoc false
  use ParzivalWeb, [:live_view, {ParzivalWeb.LayoutView, "landing.html"}]

  alias Parzival.Tools

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:current_page, "FAQs")
     |> assign(list_faqs(params))}
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
