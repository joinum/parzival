defmodule ParzivalWeb.App.ProfileLive.Edit do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id} = _params, _url, socket) do
    user = Accounts.get_user!(id, [:company])

    {:noreply,
     socket
     |> assign(:current_page, :profile)
     |> assign(:page_title, "Edit User")
     |> assign(:user, user)}
  end

  @impl true
  def handle_params(%{"qr" => qr} = _params, _url, socket) do
    user = Accounts.get_user_by_qr(qr, [:company])

    {:noreply,
     socket
     |> push_redirect(to: Routes.profile_edit_path(socket, :edit, user.id))}
  end
end
