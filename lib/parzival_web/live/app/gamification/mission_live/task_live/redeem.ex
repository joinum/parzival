defmodule ParzivalWeb.App.MissionLive.TaskLive.Redeem do
  @moduledoc false
  use ParzivalWeb, :live_view

  defp qrcode(socket, task, user_id) do
    Routes.task_path(socket, :show, task, user_id: user_id)
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(color: "#1F2937", background_color: :transparent)
  end
end
