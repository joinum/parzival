defmodule Parzival.Gamification do
  @moduledoc """
  The Gamification context.
  """

  use Parzival.Context

  alias Ecto.Multi

  alias Parzival.Accounts.User
  alias Parzival.Gamification.Curriculum
  alias Parzival.Gamification.Curriculum.Education
  alias Parzival.Gamification.Curriculum.Experience
  alias Parzival.Gamification.Curriculum.Language
  alias Parzival.Gamification.Curriculum.Position
  alias Parzival.Gamification.Curriculum.Skill
  alias Parzival.Gamification.Curriculum.Volunteering

  @doc """
  Returns the list of curriculums.

  ## Examples

      iex> list_curriculums()
      [%Curriculum{}, ...]

  """
  def list_curriculums do
    Repo.all(Curriculum)
  end

  @doc """
  Gets a single curriculum.

  Raises `Ecto.NoResultsError` if the Curriculum does not exist.

  ## Examples

      iex> get_curriculum!(123)
      %Curriculum{}

      iex> get_curriculum!(456)
      ** (Ecto.NoResultsError)

  """
  def get_curriculum!(id), do: Repo.get!(Curriculum, id)

  def get_user_curriculum(%User{} = user, preloads \\ []) do
    curriculum =
      Repo.one(
        from c in Curriculum,
          where: c.user_id == ^user.id,
          preload: ^preloads
      )

    if is_nil(curriculum) do
      %{
        summary: nil,
        experiences: [],
        educations: [],
        volunteerings: [],
        skills: [],
        languages: [],
        user_id: user.id
      }
    else
      %{
        summary:
          if curriculum.summary do
            curriculum.summary
          else
            nil
          end,
        experiences:
          if curriculum.experiences do
            Enum.map(curriculum.experiences, fn experience ->
              %{
                organization: experience.organization,
                positions: Enum.sort_by(experience.positions, & &1.finish, {:desc, Date})
              }
            end)
          else
            []
          end,
        educations:
          if curriculum.educations do
            Enum.sort_by(curriculum.educations, & &1.finish, {:desc, Date})
          else
            []
          end,
        volunteerings:
          if curriculum.volunteerings do
            Enum.sort_by(curriculum.volunteerings, & &1.finish, {:desc, Date})
          else
            []
          end,
        skills:
          if curriculum.skills do
            curriculum.skills
          else
            []
          end,
        languages:
          if curriculum.languages do
            curriculum.languages
          else
            []
          end,
        user_id:
          if curriculum.user_id do
            curriculum.user_id
          else
            user.id
          end
      }
    end
  end

  @doc """
  Creates a curriculum.

  ## Examples

      iex> create_curriculum(%{field: value})
      {:ok, %Curriculum{}}

      iex> create_curriculum(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_curriculum(attrs \\ %{}) do
    %Curriculum{}
    |> Curriculum.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a curriculum.

  ## Examples

      iex> update_curriculum(curriculum, %{field: new_value})
      {:ok, %Curriculum{}}

      iex> update_curriculum(curriculum, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_curriculum(%Curriculum{} = curriculum, attrs) do
    curriculum
    |> Curriculum.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a curriculum.

  ## Examples

      iex> delete_curriculum(curriculum)
      {:ok, %Curriculum{}}

      iex> delete_curriculum(curriculum)
      {:error, %Ecto.Changeset{}}

  """
  def delete_curriculum(%Curriculum{} = curriculum) do
    Repo.delete(curriculum)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking curriculum changes.

  ## Examples

      iex> change_curriculum(curriculum)
      %Ecto.Changeset{data: %Curriculum{}}

  """
  def change_curriculum(%Curriculum{} = curriculum, attrs \\ %{}) do
    Curriculum.changeset(curriculum, attrs)
  end

  alias Parzival.Gamification.Mission

  @doc """
  Returns the list of missions.

  ## Examples

      iex> list_missions()
      [%Mission{}, ...]

  """
  def list_missions(params \\ %{})

  def list_missions(opts) when is_list(opts) do
    Mission
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_missions(flop) do
    Flop.validate_and_run(Mission, flop, for: Mission)
  end

  def list_missions(%{} = flop, opts) when is_list(opts) do
    Mission
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Mission)
  end

  @doc """
  Gets a single mission.

  Raises `Ecto.NoResultsError` if the Mission does not exist.

  ## Examples

      iex> get_mission!(123)
      %Mission{}

      iex> get_misson!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mission!(id, preloads \\ []), do: Repo.get!(Mission, id) |> Repo.preload(preloads)

  @doc """
  Creates a missiom.

  ## Examples

      iex> create_mission(%{field: value})
      {:ok, %Mission{}}

      iex> create_mission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mission(attrs \\ %{}) do
    %Mission{}
    |> Mission.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a mission.

  ## Examples

      iex> update_mission(mission, %{field: new_value})
      {:ok, %Mission{}}

      iex> update_mission(mission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mission(%Mission{} = mission, attrs) do
    mission
    |> Mission.changeset(attrs)
    |> Repo.update()
    |> broadcast(:updated)
  end

  @doc """
  Deletes a mission.

  ## Examples

      iex> delete_mission(mission)
      {:ok, %Mission{}}

      iex> delete_mission(mission)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mission(%Mission{} = mission) do
    mission
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.foreign_key_constraint(:missions,
      name: :missions_users_mission_id_fkey,
      message: "This mission can't be deleted, because users have finish it!"
    )
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mission changes.

  ## Examples

      iex> change_mission(mission)
      %Ecto.Changeset{data: %Mission{}}

  """
  def change_mission(%Mission{} = mission, attrs \\ %{}) do
    Mission.changeset(mission, attrs)
  end

  def calc_level(exp) do
    :math.floor((:math.sqrt(2500 + 200 * exp) - 50) / 100) |> trunc()
  end

  def calc_next_level_exp(exp) do
    next_lvl = calc_level(exp) + 1

    (100 * next_lvl * (1 + next_lvl))
    |> trunc()
  end

  alias Parzival.Gamification.Mission.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks(params \\ %{})

  def list_tasks(opts) when is_list(opts) do
    Task
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_tasks(flop) do
    Flop.validate_and_run(Task, flop, for: Task)
  end

  def list_tasks(%{} = flop, opts) when is_list(opts) do
    Task
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Task)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Offer type does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id, preloads \\ []), do: Repo.get!(Task, id) |> Repo.preload(preloads)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  alias Parzival.Gamification.Mission.Dificulty

  @doc """
  Returns the list of dificulties.

  ## Examples

      iex> list_dificulties()
      [%Dificulty{}, ...]

  """
  def list_dificulties(params \\ %{})

  def list_dificulties(opts) when is_list(opts) do
    Dificulty
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_dificulties(flop) do
    Flop.validate_and_run(Dificulty, flop, for: Dificulty)
  end

  def list_dificulties(%{} = flop, opts) when is_list(opts) do
    Dificulty
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Dificulty)
  end

  @doc """
  Gets a single dificulty.

  Raises `Ecto.NoResultsError` if the Offer type does not exist.

  ## Examples

      iex> get_dificulty!(123)
      %Dificulty{}

      iex> get_dificulty!(456)
      ** (Ecto.NoResultsError)

  """
  def get_dificulty!(id), do: Repo.get!(Dificulty, id)

  @doc """
  Creates a dificulty.

  ## Examples

      iex> create_dificulty(%{field: value})
      {:ok, %Dificulty{}}

      iex> create_dificulty(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_dificulty(attrs \\ %{}) do
    %Dificulty{}
    |> Dificulty.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a dificulty.

  ## Examples

      iex> update_dificulty(dificulty, %{field: new_value})
      {:ok, %Dificulty{}}

      iex> update_dificulty(dificulty, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_dificulty(%Dificulty{} = dificulty, attrs) do
    dificulty
    |> Dificulty.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a dificulty.

  ## Examples

      iex> delete_dificulty(dificulty)
      {:ok, %Dificulty{}}

      iex> delete_dificulty(dificulty)
      {:error, %Ecto.Changeset{}}

  """
  def delete_dificulty(%Dificulty{} = dificulty) do
    dificulty
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.foreign_key_constraint(:dificulties,
      name: :missions_dificulty_id_fkey,
      message: "This dificulty cant be deleted, because some mission has it!"
    )
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking dificulty changes.

  ## Examples

      iex> change_dificulty(dificulty)
      %Ecto.Changeset{data: %Dificulty{}}

  """
  def change_dificulty(%Dificulty{} = dificulty, attrs \\ %{}) do
    Dificulty.changeset(dificulty, attrs)
  end

  alias Parzival.Gamification.Mission.MissionUser

  @doc """
  Returns the list of missions_users.

  ## Examples

      iex> list_missions_users()
      [%MissionUser{}, ...]

  """
  def list_missions_users(params \\ %{})

  def list_missions_users(opts) when is_list(opts) do
    MissionUser
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_missions_users(flop) do
    Flop.validate_and_run(MissionUser, flop, for: MissionUser)
  end

  def list_missions_users(%{} = flop, opts) when is_list(opts) do
    MissionUser
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: MissionUser)
  end

  def count_missions_users(opts \\ []) when is_list(opts) do
    MissionUser
    |> apply_filters(opts)
    |> Repo.aggregate(:count)
  end

  @doc """
  Gets a single mission_user.

  Raises `Ecto.NoResultsError` if the MissionUser does not exist.

  ## Examples

      iex> get_mission_user!(123)
      %MissionUser{}

      iex> get_misson_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mission_user!(id, preloads \\ []),
    do: Repo.get!(MissionUser, id) |> Repo.preload(preloads)

  @doc """
  Creates a mission_user.

  ## Examples

      iex> create_mission_user(%{field: value})
      {:ok, %MissionUser{}}

      iex> create_mission_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mission_user(attrs \\ %{}) do
    %MissionUser{}
    |> MissionUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a mission_user.

  ## Examples

      iex> update_mission_user(mission_user, %{field: new_value})
      {:ok, %MissionUser{}}

      iex> update_mission_user(mission_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mission_user(%MissionUser{} = mission_user, attrs) do
    mission_user
    |> MissionUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a mission_user.

  ## Examples

      iex> delete_mission_user(mission_user)
      {:ok, %MissionUser{}}

      iex> delete_mission_user(mission_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mission_user(%MissionUser{} = mission_user) do
    Repo.delete(mission_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mission_user changes.

  ## Examples

      iex> change_mission_user(mission_user)
      %Ecto.Changeset{data: %MissionUser{}}

  """
  def change_mission_user(%MissionUser{} = mission_user, attrs \\ %{}) do
    MissionUser.changeset(mission_user, attrs)
  end

  alias Parzival.Gamification.Mission.TaskUser

  @doc """
  Returns the list of tasks_users.

  ## Examples

      iex> list_tasks_users()
      [%TaskUser{}, ...]

  """
  def list_tasks_users(params \\ %{})

  def list_tasks_users(opts) when is_list(opts) do
    TaskUser
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_tasks_users(flop) do
    Flop.validate_and_run(TaskUser, flop, for: TaskUser)
  end

  def list_tasks_users(%{} = flop, opts) when is_list(opts) do
    TaskUser
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: TaskUser)
  end

  @doc """
  Gets a single task_user.

  Raises `Ecto.NoResultsError` if the TaskUser does not exist.

  ## Examples

      iex> get_task_user!(123)
      %TaskUser{}

      iex> get_misson_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task_user!(id, preloads \\ []), do: Repo.get!(TaskUser, id) |> Repo.preload(preloads)

  @doc """
  Creates a task_user.

  ## Examples

      iex> create_task_user(%{field: value})
      {:ok, %TaskUser{}}

      iex> create_task_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task_user(attrs \\ %{}) do
    %TaskUser{}
    |> TaskUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task_user.

  ## Examples

      iex> update_task_user(task_user, %{field: new_value})
      {:ok, %TaskUser{}}

      iex> update_task_user(task_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task_user(%TaskUser{} = task_user, attrs) do
    task_user
    |> TaskUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task_user.

  ## Examples

      iex> delete_task_user(task_user)
      {:ok, %TaskUser{}}

      iex> delete_task_user(task_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task_user(%TaskUser{} = task_user) do
    Repo.delete(task_user)
  end

  def redeem_task(%User{} = user, %Task{} = task, %User{} = staff) do
    Multi.new()
    |> Multi.insert(
      :task_user,
      TaskUser.changeset(%TaskUser{}, %{user_id: user.id, staff_id: staff.id, task_id: task.id})
    )
    |> Multi.update(
      :update_user,
      User.task_completion_changeset(user, %{
        balance: user.balance + task.tokens,
        exp: user.exp + task.exp
      })
    )
    |> Multi.run(:mission, fn repo, _change ->
      mission = Parzival.Gamification.get_mission!(task.mission_id, tasks: [:users])

      case Enum.all?(mission.tasks, fn task -> Enum.any?(task.users, &(&1.id == user.id)) end) do
        true ->
          %MissionUser{}
          |> MissionUser.changeset(%{mission_id: mission.id, user_id: user.id})
          |> repo.insert()

          user
          |> User.task_completion_changeset(%{
            balance: user.balance + mission.tokens,
            exp: user.exp + mission.exp
          })
          |> repo.update()

          {:ok, mission}

        _ ->
          {:ok, mission}
      end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, transaction} ->
        broadcast({:ok, transaction.mission}, :updated)

      {:error, _transaction, changeset, _} ->
        {:error, changeset}
    end
  end

  def is_task_completed?(task_id, user_id) do
    from(t in TaskUser, where: t.task_id == ^task_id and t.user_id == ^user_id)
    |> Repo.exists?()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task_user changes.

  ## Examples

      iex> change_task_user(task_user)
      %Ecto.Changeset{data: %TaskUser{}}

  """
  def change_task_user(%TaskUser{} = task_user, attrs \\ %{}) do
    TaskUser.changeset(task_user, attrs)
  end

  def change_education(
        %Education{} = education,
        attrs \\ %{}
      ) do
    Education.changeset(education, attrs)
  end

  def change_experience(
        %Experience{} = experience,
        attrs \\ %{}
      ) do
    Experience.changeset(experience, attrs)
  end

  def change_language(
        %Language{} = language,
        attrs \\ %{}
      ) do
    Language.changeset(language, attrs)
  end

  def change_position(
        %Position{} = position,
        attrs \\ %{}
      ) do
    Position.changeset(position, attrs)
  end

  def change_skill(
        %Skill{} = skill,
        attrs \\ %{}
      ) do
    Skill.changeset(skill, attrs)
  end

  def change_volunteering(
        %Volunteering{} = volunteering,
        attrs \\ %{}
      ) do
    Volunteering.changeset(volunteering, attrs)
  end

  def subscribe(topic) do
    Phoenix.PubSub.subscribe(Parzival.PubSub, topic)
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, %Mission{} = mission}, event) when event in [:updated] do
    Phoenix.PubSub.broadcast!(Parzival.PubSub, "updated:#{mission.id}", {event, mission})
    {:ok, mission}
  end
end
