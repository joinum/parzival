defmodule ParzivalWeb.App.TaskLive.Show do
  @moduledoc false
  use ParzivalWeb, :live_view

  import ParzivalWeb.Components.Pagination

  alias Parzival.Accounts
  alias Parzival.Gamification
  alias Parzival.Store

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => mission_id, "task_id" => task_id} = params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :missions)
     |> assign(:params, params)
     |> assign(:attendees_count, Accounts.count_users(where: [role: :attendee]))
     |> assign(:mission, Gamification.get_mission!(mission_id))
     |> assign(
       :is_task_completed?,
       Gamification.is_task_completed?(task_id, socket.assigns.current_user.id)
     )
     |> assign(
       :has_skip_task?,
       Store.has_skip_task?(socket.assigns.current_user.id)
     )
     |> assign(
       :skip_task_boost,
       Store.get_skip_task_boost()
     )
     |> assign(list_completed_tasks_users(params))
     |> assign(:task, Gamification.get_task!(task_id))
     |> assign(:qrcode, qrcode(socket, task_id))
     |> apply_action(socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("skip-task", _, socket) do
    task = socket.assigns.task
    user = socket.assigns.current_user

    Gamification.skip_task(user, task)

    {:noreply,
     socket
     |> assign(inventory: Store.list_inventory(where: [user_id: user.id], preloads: [:boost]))}
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Show Task")
  end

  defp apply_action(socket, :redeem, _params) do
    socket
    |> assign(:page_title, "Redeem Task")
  end

  defp qrcode(socket, task_id) do
    Routes.admin_task_redeem_url(socket, :redeem, task_id, socket.assigns.current_user.id)
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(color: "#1F2937", width: 295, background_color: :transparent)
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
