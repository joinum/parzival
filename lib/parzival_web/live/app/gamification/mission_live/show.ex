defmodule ParzivalWeb.App.MissionLive.Show do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Accounts
  alias Parzival.Gamification

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Gamification.subscribe("updated:#{id}")
    end

    {:ok, assign(socket, :id, id)}
  end

  @impl true
  def handle_params(%{"id" => _id}, _, socket) do
    socket =
      socket
      |> assign(:current_page, :missions)
      |> assign(:page_title, "Show Mission")
      |> assign(:attendees_count, Accounts.count_users(where: [role: :attendee]))

    {:noreply, reload(socket)}
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

  @impl true
  def handle_info({event, _changes}, socket) when event in [:updated] do
    {:noreply, reload(socket)}
  end

  defp reload(socket) do
    id = socket.assigns.id

    socket
    |> assign(:mission, Gamification.get_mission!(id, [:dificulty, :created_by, tasks: [:users]]))
    |> assign(:count_mission_users, Gamification.count_missions_users(where: [mission_id: id]))
    |> assign(
      :mission_users,
      Gamification.list_missions_users(
        where: [mission_id: id],
        limit: 12,
        order_by: [:inserted_at],
        preloads: [user: :missions]
      )
    )
  end
end
