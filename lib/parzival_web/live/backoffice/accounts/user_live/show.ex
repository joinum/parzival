defmodule ParzivalWeb.Backoffice.UserLive.Show do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = params, _url, socket) do
    user = Accounts.get_user!(id)

    {:noreply,
     socket
     |> assign(:current_page, :accounts)
     |> assign(:current_tab, user.role)
     |> assign(:page_title, "Show User")
     |> assign(:params, params)
     |> assign(:user, user)}
  end

  @impl true
  def handle_event("delete", _payload, socket) do
    {:ok, _} = Accounts.delete_user(socket.assigns.user)

    {:noreply,
     push_redirect(socket,
       to:
         Routes.admin_user_index_path(socket, :index, %{
           "filters" => %{"0" => %{"field" => "role", "value" => socket.assigns.user.role}}
         })
     )}
  end
end
