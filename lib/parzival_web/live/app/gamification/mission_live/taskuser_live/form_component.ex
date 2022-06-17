defmodule ParzivalWeb.App.MissionLive.TaskUserLive.FormComponent do
  @moduledoc false
  use ParzivalWeb, :live_component

  alias Parzival.Gamification
  alias Parzival.Accounts

  @impl true
  def update(%{attendee: attendee, task: task} = assigns, socket) do

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, nil)}
  end


  def handle_event("save", __params, socket) do
    redeem_task(socket, socket.assigns.current_user, socket.assigns.attendee, socket.assigns.task)
  end

  defp redeem_task(socket, staff, attendee, task) do
    case Gamification.redeem_task(staff, attendee, task) do
      {:ok, __taskuser} ->

        {:noreply,
         socket
         |> put_flash(:success, "Task redeemed successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(changeset: changeset)}
    end
  end

end
