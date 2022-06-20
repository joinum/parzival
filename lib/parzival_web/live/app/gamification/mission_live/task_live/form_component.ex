defmodule ParzivalWeb.App.MissionLive.TaskLive.FormComponent do
  @moduledoc false
  use ParzivalWeb, :live_component

  @impl true
  def update(%{task: task, mission: _mission, user_id: user_id} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:qrcode, qrcode(socket, task, user_id))}
  end

  defp qrcode(socket, task, user_id) do
    Routes.staff_task_user_new_url(socket, :new, task.id, user_id)
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(color: "#1F2937", width: 295, background_color: :transparent)
  end
end
