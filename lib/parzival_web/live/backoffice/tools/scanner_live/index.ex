defmodule ParzivalWeb.Backoffice.ScannerLive.Index do
  @moduledoc false
  use ParzivalWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :scanner)
     |> assign(:page_title, "Scan QR")}
  end

  @impl true
  def handle_event("scan", pathname, socket) do
    {:noreply, push_redirect(socket, to: "/#{duck_tape(pathname)}")}
  end

  defp duck_tape(pathname) do
    # This is a nice story
    # It is currently the afternoon of the event. We had an issue where connections
    # were throwing 500, but the connection was being created regardless.
    # The problem is the credentials were pointing to /profile/:qr, which works as
    # an unprotected route. However, if the user is logged in, the credential should
    # redirect to /profile/app/:qr for everything to work.
    # This function makes that change to the link
    Regex.replace(~r/(https:\/\/join.di.uminho.pt)(.*)/, pathname, "\\1/app\\2")
  end
end
