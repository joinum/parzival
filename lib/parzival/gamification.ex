defmodule Parzival.Gamification do
  @moduledoc """
  The Gamification context.
  """

  use Parzival.Context

  alias Ecto.Multi

  alias Parzival.Accounts
  alias Parzival.Accounts.User
  alias Parzival.Gamification.Curriculum
  alias Parzival.Gamification.Curriculum.Education
  alias Parzival.Gamification.Curriculum.Experience
  alias Parzival.Gamification.Curriculum.Language
  alias Parzival.Gamification.Curriculum.Position
  alias Parzival.Gamification.Curriculum.Skill
  alias Parzival.Gamification.Curriculum.Volunteering

  @first_day_start Application.get_env(:parzival, :event)[:first_day_start]
  @first_day_end Application.get_env(:parzival, :event)[:first_day_end]
  @second_day_start Application.get_env(:parzival, :event)[:second_day_start]
  @second_day_end Application.get_env(:parzival, :event)[:second_day_end]
  @third_day_start Application.get_env(:parzival, :event)[:third_day_start]
  @third_day_end Application.get_env(:parzival, :event)[:third_day_end]

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
      get_ordered_curriculum(curriculum, user)
    end
  end

  defp get_ordered_curriculum(curriculum, user) do
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
              positions:
                Enum.sort_by(
                  experience.positions,
                  &if is_nil(&1.finish) do
                    Date.utc_today()
                  else
                    &1.finish
                  end,
                  {:desc, Date}
                )
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

  alias Parzival.Gamification.Mission.Difficulty

  @doc """
  Returns the list of difficulties.

  ## Examples

      iex> list_difficulties()
      [%Difficulty{}, ...]

  """
  def list_difficulties(params \\ %{})

  def list_difficulties(opts) when is_list(opts) do
    Difficulty
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_difficulties(flop) do
    Flop.validate_and_run(Difficulty, flop, for: Difficulty)
  end

  def list_difficulties(%{} = flop, opts) when is_list(opts) do
    Difficulty
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Difficulty)
  end

  @doc """
  Gets a single difficulty.

  Raises `Ecto.NoResultsError` if the Offer type does not exist.

  ## Examples

      iex> get_difficulty!(123)
      %Difficulty{}

      iex> get_difficulty!(456)
      ** (Ecto.NoResultsError)

  """
  def get_difficulty!(id), do: Repo.get!(Difficulty, id)

  @doc """
  Creates a difficulty.

  ## Examples

      iex> create_difficulty(%{field: value})
      {:ok, %Difficulty{}}

      iex> create_difficulty(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_difficulty(attrs \\ %{}) do
    %Difficulty{}
    |> Difficulty.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a difficulty.

  ## Examples

      iex> update_difficulty(difficulty, %{field: new_value})
      {:ok, %Difficulty{}}

      iex> update_difficulty(difficulty, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_difficulty(%Difficulty{} = difficulty, attrs) do
    difficulty
    |> Difficulty.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a difficulty.

  ## Examples

      iex> delete_difficulty(difficulty)
      {:ok, %Difficulty{}}

      iex> delete_difficulty(difficulty)
      {:error, %Ecto.Changeset{}}

  """
  def delete_difficulty(%Difficulty{} = difficulty) do
    difficulty
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.foreign_key_constraint(:difficulties,
      name: :missions_difficulty_id_fkey,
      message: "This difficulty cant be deleted, because some mission has it!"
    )
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking difficulty changes.

  ## Examples

      iex> change_difficulty(difficulty)
      %Ecto.Changeset{data: %Difficulty{}}

  """
  def change_difficulty(%Difficulty{} = difficulty, attrs \\ %{}) do
    Difficulty.changeset(difficulty, attrs)
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

  def get_leaderboard(day, number_entries) do
    case day do
      # 0 -> get_general_leaderboard(params, number_entries)
      0 -> get_daily_leaderboard(@first_day_start, @third_day_end, number_entries)
      1 -> get_daily_leaderboard(@first_day_start, @first_day_end, number_entries)
      2 -> get_daily_leaderboard(@second_day_start, @second_day_start, number_entries)
      3 -> get_daily_leaderboard(@third_day_start, @third_day_end, number_entries)
    end
  end

  def get_exp(user, day) do
    case day do
      1 -> get_exp(user, @first_day_start, @first_day_end)
      2 -> get_exp(user, @second_day_start, @second_day_end)
      3 -> get_exp(user, @third_day_start, @third_day_end)
    end
  end

  defp get_exp(user, start_time, end_time) do
    q2 = get_leaderboard_query(start_time, end_time)

    res =
      subquery(q2)
      |> where([t], t.user == ^user.id)
      |> select([t], t.experience)
      |> Repo.one()

    if res == nil do
      0
    else
      res
    end
  end

  defp get_leaderboard_query(start_time, end_time) do
    q1 =
      TaskUser
      |> where([tu], tu.inserted_at <= ^end_time and tu.inserted_at >= ^start_time)
      |> join(:inner, [tu], t in Task, on: t.id == tu.task_id)
      |> join(:inner, [t], u in User, on: u.id == t.user_id)
      |> select([tu, t], %{task: tu.task_id, exp: t.exp, user: tu.user_id})

    subquery(q1)
    |> group_by([t], t.user)
    |> select([t], %{user: t.user, experience: sum(t.exp)})
  end

  defp get_daily_leaderboard(start_time, end_time, number_entries) do
    q2 = get_leaderboard_query(start_time, end_time)

    subquery(q2)
    |> order_by([t], desc: t.experience)
    |> limit(^number_entries)
    |> join(:inner, [t], u in User, on: t.user == u.id)
    |> Repo.all()
  end

  def get_user_position(user, day) do
    case day do
      0 -> get_user_position_general(user)
      1 -> get_user_position_by_day(user, @first_day_start, @second_day_end)
      2 -> get_user_position_by_day(user, @second_day_start, @second_day_end)
      3 -> get_user_position_by_day(user, @third_day_start, @third_day_end)
    end
  end

  defp get_user_position_general(user) do
    x =
      User
      |> where([u], u.exp > ^user.exp)
      |> Repo.aggregate(:count, :id)

    x + 1
  end

  defp get_user_position_by_day(user, start_time, end_time) do
    q2 = get_leaderboard_query(start_time, end_time)

    exp =
      subquery(q2)
      |> where([t], t.user == ^user.id)
      |> select([t], t.experience)
      |> Repo.one()

    if exp == nil do
      '-'
    else
      x =
        subquery(q2)
        |> where([t], t.experience > ^exp)
        |> Repo.aggregate(:count, :user)

      x + 1
    end
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
