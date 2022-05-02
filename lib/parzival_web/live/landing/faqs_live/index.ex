defmodule ParzivalWeb.Landing.FaqsLive.Index do
  @moduledoc false
  use ParzivalWeb, [:live_view, {ParzivalWeb.LayoutView, "landing.html"}]

  alias Parzival.Tools

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:current_page, "FAQs")
     |> assign(:faqs, Tools.list_faqs())}
  end
end
