defmodule ParzivalWeb.Backoffice.TaskLive.Redeem do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Accounts
  alias Parzival.Gamification

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"task_id" => task_id, "attendee_id" => attendee_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :tasks)
     |> assign(:page_title, "Give task")
     |> assign(:attendee, Accounts.get_user!(attendee_id, [:missions]))
     |> assign(:task, Gamification.get_task!(task_id))
     |> assign(:return_to, Routes.admin_scanner_index_path(socket, :index))
     |> assign(:is_completed, Gamification.is_task_completed?(task_id, attendee_id))}
  end
end
