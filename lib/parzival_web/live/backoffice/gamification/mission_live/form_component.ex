defmodule ParzivalWeb.Backoffice.MissionLive.FormComponent do
  @moduledoc false
  use ParzivalWeb, :live_component

  alias Parzival.Companies
  alias Parzival.Gamification
  alias Parzival.Gamification.Mission.Task

  @impl true
  def update(%{mission: mission} = assigns, socket) do
    changeset = Gamification.change_mission(mission)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:difficulties, list_difficulties())
     |> assign(:companies, list_companies())
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"mission" => mission_params}, socket) do
    changeset =
      socket.assigns.mission
      |> Gamification.change_mission(mission_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("add-task", _, socket) do
    changeset = socket.assigns.changeset

    tasks =
      changeset
      |> Ecto.Changeset.get_field(:tasks)
      |> Enum.concat([Gamification.change_task(%Task{})])

    changeset =
      changeset
      |> Ecto.Changeset.put_assoc(:tasks, tasks)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("rm-task", %{"index" => index}, socket) do
    tasks =
      Map.get(socket.assigns.changeset.changes, :tasks)
      |> List.delete_at(String.to_integer(index))

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:tasks, tasks)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"mission" => mission_params}, socket) do
    mission_params =
      if socket.assigns.current_user.role in [:recruiter] do
        mission_params
        |> Map.put("created_by_id", socket.assigns.current_user.company_id)
      else
        mission_params
      end

    save_mission(socket, socket.assigns.action, mission_params)
  end

  defp list_difficulties do
    Gamification.list_difficulties(fields: [:name, :id])
  end

  defp list_companies do
    Companies.list_companies(fields: [:name, :id])
  end

  defp save_mission(socket, :edit, mission_params) do
    case Gamification.update_mission(socket.assigns.mission, mission_params) do
      {:ok, _mission} ->
        {:noreply,
         socket
         |> put_flash(:info, "Mission updated successfully!")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_mission(socket, :new, mission_params) do
    tasks =
      mission_params
      |> Map.get("tasks")
      |> Enum.map(fn {_id, task} -> Map.drop(task, ["id", "mission_id"]) end)

    mission_params = Map.replace!(mission_params, "tasks", tasks)

    case Gamification.create_mission(mission_params) do
      {:ok, _mission} ->
        {:noreply,
         socket
         |> put_flash(:success, "Mission created successfully!")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
