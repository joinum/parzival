defmodule ParzivalWeb.App.HomeLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Accounts
  alias Parzival.Tools

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    user = Accounts.get_user!(socket.assigns.current_user.id)

    {:noreply,
     socket
     |> assign(:current_page, :home)
     |> assign(:announcements, list_announcements())
     |> assign(:user, user)}
  end

  @impl true
  def handle_event("add-exp", _payload, socket) do
    case Accounts.add_exp(socket.assigns.current_user) do
      {:ok, user} ->
        {:noreply, assign(socket, :current_user, user)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp list_announcements do
    Tools.list_announcements(preloads: [:author], limit: 3, order_by: [desc: :inserted_at])
  end
end
