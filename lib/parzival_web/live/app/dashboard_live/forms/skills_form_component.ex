defmodule ParzivalWeb.App.DashboardLive.SkillsFormComponent do
  @moduledoc false
  use ParzivalWeb, :live_component

  alias Parzival.Gamification

  @impl true
  def update(%{curriculum: curriculum} = assigns, socket) do
    changeset = Gamification.change_curriculum(curriculum)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"curriculum" => curriculum_params}, socket) do
    changeset =
      socket.assigns.curriculum
      |> Gamification.change_curriculum(curriculum_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"curriculum" => curriculum_params}, socket) do
    save_curriculum(socket, curriculum_params)
  end

  defp save_curriculum(socket, curriculum_params) do
    case Gamification.update_curriculum(socket.assigns.curriculum, curriculum_params) do
      {:ok, _curriculum} ->
        {:noreply,
         socket
         |> put_flash(:success, "Summary updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   skill = Gamification.skill!(id)
  #   {:ok, _} = Gamification.delete_skill(skill)

  #   {:noreply, assign(socket, list_offer_times(%{}))}
  # end
end
