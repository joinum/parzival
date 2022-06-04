defmodule ParzivalWeb.App.MissionLive.Show do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Accounts
  alias Parzival.Gamification

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :missions)
     |> assign(:page_title, "Show Mission")
     |> assign(:attendees, Accounts.list_users(where: [role: :attendee]))
     |> assign(
       :mission,
       Gamification.get_mission!(id, [
         :dificulty,
         :created_by,
         users: [:missions],
         tasks: [:users]
       ])
     )}
  end

  @impl true
  def handle_event("delete", _payload, socket) do
    case Gamification.delete_mission(socket.assigns.mission) do
      {:ok, _mission} ->
        {:noreply,
         socket
         |> put_flash(:success, "Mission deleted successfully!")
         |> push_redirect(to: Routes.mission_index_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, elem(changeset.errors[:missions], 0))
         |> assign(:changeset, changeset)}
    end
  end
end
