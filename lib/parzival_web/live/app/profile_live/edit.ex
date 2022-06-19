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
    user = Accounts.get_user!(id)

    {:noreply,
     socket
     |> assign(:current_page, :profile)
     |> assign(:page_title, "Edit User")
     |> assign(:user, user)}
  end
end
