defmodule ParzivalWeb.Backoffice.UserLive.Index do
  @moduledoc false

  use ParzivalWeb, :live_view

  alias Parzival.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(
        %{"filters" => %{"0" => %{"field" => "role", "value" => _role}}} = params,
        _url,
        socket
      ) do
    # tab =
    #   case role do
    #     "admin" -> :admin
    #     "staff" -> :staff
    #     "attendee" -> :attendee
    #     "company" -> :company
    #   end

    {:noreply,
     socket
     |> assign(:current_page, :accounts)
     |> assign(:users, Accounts.list_users(params))}
  end
end
