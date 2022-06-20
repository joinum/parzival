defmodule ParzivalWeb.App.ProfileLive.Assign do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Accounts
  alias Parzival.Credentials

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => attendee} = _params, _url, socket) do
    user = Accounts.get_user!(attendee)

    {:noreply,
     socket
     |> assign(:current_page, :profile)
     |> assign(:page_title, "Assign QR")
     |> assign(:attendee, user)}
  end

  def handle_event("save", %{"qr" => qr}, socket) do
    assign_qr(socket.assigns.attendee.id, qr, socket)
  end

  defp assign_qr(attendee, qr, socket) do
    case Credentials.assign_qr(attendee, qr) do
      {:ok, _qr} ->
        {:noreply,
          socket
          |> put_flash(:success, "Credential sucessfully linked")
          |> push_redirect(to: socket.assigns.return_to)}
      #{:error, %Ecto.Changeset{} = changeset} ->
       # {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
