defmodule ParzivalWeb.Backoffice.UserLive.New do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"role" => role}, _url, socket) do
    tab =
      case role do
        "admin" -> :admin
        "staff" -> :staff
        "attendee" -> :attendee
        "company" -> :company
      end

    {:noreply,
     socket
     |> assign(:current_page, :accounts)
     |> assign(:current_tab, tab)
     |> assign(:user, %User{})}
  end
end
