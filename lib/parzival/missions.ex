defmodule Parzival.Missions do
  @moduledoc """
  The Missions context.
  """
  use Parzival.Context

  import Ecto.Query, warn: false

  alias Parzival.Missions.{Mission, Task, TaskCompletion}
  alias Parzival.Accounts.{User, UserNotifier, UserToken}
  alias Parzival.Repo

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

  def list_TaskCompletions(params \\ %{})

  def list_TaskCompletions(opts) when is_list(opts) do
    TaskCompletion
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_TaskCompletions(flop) do
    Flop.validate_and_run(TaskCompletion, flop, for: TaskCompletion)
  end

  def list_TaskCompletions(%{} = flop, opts) when is_list(opts) do
    TaskCompletion
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: TaskCompletion)
  end

   ## Database getters


  @doc """
  Gets a single Mission.

  Raises `Ecto.NoResultsError` if the Mission does not exist.

  ## Examples

      iex> get_mission!(123)
      %Mission{}

      iex> get_mission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mission!(id), do: Repo.get(Mission, id)

  @doc """
  Gets a single k.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get(Task, id)

  @doc """
  Gets all tasks needed to complete a mission.

  Raises `Ecto.NoResultsError` if no tasks exist.

  ## Examples

      iex> get_tasks_of_mission!(123)
      [%Task{}]

      iex> get_tasks_of_mission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tasks_of_mission!(mission_id) do
    Repo.get_by(Task, mission_id: mission_id)
  end

  @doc """
  Gets all tasks completed by a participant.

  Raises `Ecto.NoResultsError` if no tasks exist.

  ## Examples

      iex> get_tasks_of_participant!(123)
      [%Task{}]

      iex> get_tasks_of_participant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tasks_of_participant!(participant_id) do
    Repo.get_by(Task, participant_id: participant_id)
  end

  @doc """
  Gets all tasks of a mission completed by a participant.

  Raises `Ecto.NoResultsError` if no tasks exist.

  ## Examples

      iex> get_tasks_of_participant!(123, 123)
      [%Task{}]

      iex> get_tasks_of_participant!(456, 456)
      ** (Ecto.NoResultsError)

  """
  def get_tasks_of_participant!(participant_id, mission_id) do
    Repo.get_by(Task, mission_id: mission_id, participant_id: participant_id)
  end

  @doc """
  Gets all missions completed by a participant.

  Raises `Ecto.NoResultsError` if no missions exist.

  ## Examples

      iex> get_missions_of_participant!(123)
      [%Mission{}]

      iex> get_missions_of_participant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_missions_of_participant!(participant_id) do
    ##Mission
    #|> where([m], subquery(from t in Task, limit: 10
      ##Task
      ##|> where([t], subquery(
      ##  TaskCompletion
     ##   |> where([tc], tc.participant_id == participant_id && tc.task_id == t.id)
      ##  |> Repo.exists
     ## ) && t.mission_id == mission_id)
     ## |> Repo.aggregate(:count, :mission_id)
    #))
    #  == []
      ##subquery(TaskCompletion
      ##|> where([p], p.mission_id == m.id)
      ##|> Repo.aggregate(:count, :mission_id)))
    #|> Repo.all
    "Ola"
  end

  @doc """
  Gets all participants who have completed a mission

  Raises `Ecto.NoResultsError` if no participants exist.

  ## Examples

      iex> get_participants_with_mission!(123)
      [%Participant{}]

      iex> get_participants_with_mission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_participants_with_mission!(mission_id) do

    query = subquery(mission_completions_query)
    |> where([mc], mc.mission == ^mission_id)
    |> select([mc], %{"user": mc.user})

    subquery(query)
    |> join(:left, [users], u in User, on: u.id == users.user)
    |> select([sq, u], u)
    |> Repo.all
  end

  @doc """
  Gets all participants who have completed a task

  Raises `Ecto.NoResultsError` if no participants exist.

  ## Examples

      iex> get_participants_with_task!(123)
      [%Participant{}]

      iex> get_participants_with_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_participants_with_task!(task_id) do
    "Ola"
  end

  @doc """
  Marks a task as completed by a participant

  TODO::Documentation and verify user types
  """
  def give_task(user_id, staff_id, task_id) do
    user  = User
           |> Repo.get_by(id: user_id)

    staff = User
           |> Repo.get_by(id: staff_id)

    task  = Task
           |> Repo.get_by(id: task_id)

    %TaskCompletion{participant: user, staff: staff, task: task}
    |> Repo.insert
  end

  @doc """
  Registers a user.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a mission.

  ## Examples

      iex> create_mission(%{field: value})
      {:ok, %Mission{}}

      iex> create_mission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mission(attrs) do
    %Mission{}
    |> Mission.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
    Gets the query used to determine which missions completed by which attendees
  """
  defp mission_completions_query() do
    mission_number_of_tasks =
      Mission
      |> join(:inner, [m], t in Task, on: t.mission_id == m.id)
      |> group_by([m,t], m.id)
      |> select([m,t], %{"mission": m.id, "task_count": count(t.id)})


    user_task_completions =
      User
      |> join(:inner, [u], tc in TaskCompletion, on: tc.participant_id == u.id)
      |> select([u, tc], %{"user": u.id, "task": tc.task_id})

    user_tasks =
      subquery(user_task_completions)
      |> join(:inner, [utc], t in Task, on: utc.task == t.id)
      |> select([utc, t], %{"user": utc.user, "task": t.id, "mission": t.mission_id})

    user_missions =
      subquery(user_tasks)
      |> join(:inner, [ut], m in Mission, on: m.id == ut.mission)
      |> group_by([ut, m], [ut.mission, ut.user])
      |> select([ut, m], %{"user": ut.user, "mission": ut.mission, "task_count": count(ut.task)})

    participants_with_mission =
      subquery(user_missions)
      |> join(:inner, [um], m_tasks in subquery(mission_number_of_tasks), on: m_tasks.mission == um.mission and um.task_count == m_tasks.task_count)
      |> select([um, m_tasks], %{"user": um.user, "mission": um.mission})
  end
end
