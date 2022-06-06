defmodule ParzivalWeb.App.MissionLive.TaskLive.Show do
  @moduledoc false
  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Pagination

  alias Parzival.Gamification
  alias Parzival.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"mission_id" => mission_id, "task_id" => task_id} = params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :missions)
     |> assign(:page_title, "Show Task")
     |> assign(:params, params)
     |> assign(:attendees_count, Accounts.count_users(where: [role: :attendee]))
     |> assign(:mission, Gamification.get_mission!(mission_id))
     |> assign(list_completed_tasks_users(params))
     |> assign(:task, Gamification.get_task!(task_id))}
  end

  @impl true
  def handle_event("delete", _args, socket) do
    {:ok, _} = Gamification.delete_task(socket.assigns.task)

    {:noreply,
     socket
     |> put_flash(:success, "Task deleted successfully!")
     |> push_redirect(to: Routes.mission_show_path(socket, :index, socket.assigns.mission))}
  end

  defp list_completed_tasks_users(%{"task_id" => task_id} = params) do
    params =
      params
      |> Map.put("page_size", 12)

    case Gamification.list_tasks_users(params,
           preloads: [user: [:missions]],
           where: [task_id: task_id]
         ) do
      {:ok, {task_users, meta}} ->
        %{task_users: task_users, meta: meta}

      {:error, flop} ->
        %{task_users: [], meta: flop}
    end
  end
end
