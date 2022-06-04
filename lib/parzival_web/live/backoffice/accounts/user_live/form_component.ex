defmodule ParzivalWeb.Backoffice.UserLive.FormComponent do
  @moduledoc false
  use ParzivalWeb, :live_component

  alias Parzival.Gamification
  alias Parzival.Gamification.Curriculum.Education
  alias Parzival.Gamification.Curriculum.Experience
  alias Parzival.Gamification.Curriculum.Language
  alias Parzival.Gamification.Curriculum.Position
  alias Parzival.Gamification.Curriculum.Skill
  alias Parzival.Gamification.Curriculum.Volunteering

  @impl true
  def update(%{curriculum: curriculum} = assigns, socket) do
    changeset = Gamification.change_curriculum(curriculum)

    proficiencies = [:Native, :Fluent, :Intermediary, :Basic]

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:proficiencies, proficiencies)
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

  def handle_event("add-skill", _, socket) do
    existing_skills =
      Map.get(
        socket.assigns.changeset.changes,
        :skills,
        socket.assigns.curriculum.skills
      )

    skills =
      existing_skills
      |> Enum.concat([Gamification.change_skill(%Skill{})])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_embed(:skills, skills)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("rm-skill", %{"index" => index}, socket) do
    skills =
      Map.get(socket.assigns.changeset.changes, :skills)
      |> List.delete_at(String.to_integer(index))

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_embed(:skills, skills)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("add-language", _, socket) do
    existing_languages =
      Map.get(
        socket.assigns.changeset.changes,
        :languages,
        socket.assigns.curriculum.languages
      )

    languages =
      existing_languages
      |> Enum.concat([Gamification.change_language(%Language{})])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_embed(:languages, languages)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("rm-language", %{"index" => index}, socket) do
    languages =
      Map.get(socket.assigns.changeset.changes, :languages)
      |> List.delete_at(String.to_integer(index))

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_embed(:languages, languages)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("add-education", _, socket) do
    existing_educations =
      Map.get(
        socket.assigns.changeset.changes,
        :educations,
        socket.assigns.curriculum.educations
      )

    educations =
      existing_educations
      |> Enum.concat([Gamification.change_education(%Education{})])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_embed(:educations, educations)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("rm-education", %{"index" => index}, socket) do
    educations =
      Map.get(socket.assigns.changeset.changes, :educations)
      |> List.delete_at(String.to_integer(index))

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_embed(:educations, educations)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("add-volunteering", _, socket) do
    existing_volunteerings =
      Map.get(
        socket.assigns.changeset.changes,
        :volunteerings,
        socket.assigns.curriculum.volunteerings
      )

    volunteerings =
      existing_volunteerings
      |> Enum.concat([Gamification.change_volunteering(%Volunteering{})])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_embed(:volunteerings, volunteerings)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("rm-volunteering", %{"index" => index}, socket) do
    volunteerings =
      Map.get(socket.assigns.changeset.changes, :volunteerings)
      |> List.delete_at(String.to_integer(index))

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_embed(:volunteerings, volunteerings)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("add-experience", _, socket) do
    existing_experiences =
      Map.get(
        socket.assigns.changeset.changes,
        :experiences,
        socket.assigns.curriculum.experiences
      )

    experiences =
      existing_experiences
      |> Enum.concat([Gamification.change_experience(%Experience{})])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_embed(:experiences, experiences)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("rm-experience", %{"index" => index}, socket) do
    experiences =
      Map.get(socket.assigns.changeset.changes, :experiences)
      |> List.delete_at(String.to_integer(index))

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_embed(:experiences, experiences)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("add-position", _, socket) do
    existing_positions =
      Map.get(
        socket.assigns.changeset.changes,
        :positions,
        socket.assigns.curriculum.positions
      )

    positions =
      existing_positions
      |> Enum.concat([Gamification.change_position(%Position{})])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_embed(:positions, positions)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("rm-position", %{"index" => index}, socket) do
    positions =
      Map.get(socket.assigns.changeset.changes, :positions)
      |> List.delete_at(String.to_integer(index))

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_embed(:positions, positions)

    {:noreply, assign(socket, changeset: changeset)}
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
end
