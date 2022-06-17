defmodule ParzivalWeb.App.Staff.TaskUserLive.New do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Gamification
  alias Parzival.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"task" => task, "attendee" => attendee}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :tasks)
     |> assign(:page_title, "Give task")
     |> assign(:attendee, Accounts.get_user!(attendee, [:missions]))
     |> assign(:task, Gamification.get_task!(task))
     |> assign(:return_to, Routes.scanner_index_path(socket, :index))
     |> assign(:is_completed, Gamification.is_task_completed?(task, attendee))}
  end
end
