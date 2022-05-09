defmodule ParzivalWeb.App.CompanyLive.New do
  use ParzivalWeb, :live_view

  alias Parzival.Companies.Company

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :jobs)
     |> assign(:page_title, "New Company")
     |> assign(:company, %Company{})}
  end
end
