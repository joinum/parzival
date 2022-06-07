defmodule ParzivalWeb.App.MissionLive.TaskLive.FormComponent do
  @moduledoc false
  use ParzivalWeb, :live_component

  @impl true
  def update(%{task: task, mission: mission, user_id: user_id} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:qrcode, qrcode(socket, task, mission, user_id))}
  end

  defp qrcode(socket, task, mission, user_id) do
    Routes.mission_task_show_url(socket, :show, mission, task, user_id: user_id)
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(color: "#1F2937", width: 295, background_color: :transparent)
  end
end
