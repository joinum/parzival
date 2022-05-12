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
    # number_of_tasks_per_mission
    #   = from m in Mission,
    #           join: t in Task, on: t.mission_id == m.id

    # user_tasks_completed
    #   = from u in User,
    #       join: tc in TaskCompletion, tc.participant_id == u.id


    # user_tasks
    #   = from u in subquery(user_tasks_completed),
    #       join: t in Task, on: t.id ==


    # query3 = from m in Mission,

    # query2 = Task
    #          |> exists([t], subquery(query))
    #          |> Repo.all

    #User
    #|> select(User)
    #|> Repo.all

    # Participant
    # |> where([p], subquery(
    #   Task
    #   |> where([t], subquery(
    #     TaskCompletion
    #     |> where([tc], tc.participant_id == p.id and tc.task_id == t.id)
    #     |> Repo.exists
    #   ) and t.mission_id == mission_id)
    #   |> Repo.aggregate(:count, :mission_id)
    # )
    #   ==
    #   subquery(Task
    #   |> where([p], p.mission_id == mission_id)
    #   |> Repo.aggregate(:count, :mission_id)))
    # |> Repo.all
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
    mission_number_of_tasks =
      from m in Mission,
        join: t in Task, on: t.mission_id == m.id,
        select: %{"mission": m.id, "count": count(t.id)}

    user_task_completions =
      from u in User,
        join: tc in TaskCompletion, on: tc.participant_id == u.id,
        select: {u, tc.task_id}

    user_tasks =
      from [u, task_id] in subquery(user_task_completions),
        join: t in Task, on: task_id == t.id,
        select: {u, t.id, t.mission_id}

    user_missions =
      from [u, task_id, mission_id] in subquery(user_tasks),
        join: m in Mission, on: m.id == mission_id,
        group_by: u.id,
        select: {u, mission_id, count(m.id)}

    participants_with_mission =
      from [user, mission_id, task_count] in user_missions,
        join: mim in subquery(mission_number_of_tasks), on: mim.mission == mission_id and mim.count == task_count,
        select: {user}

    Repo.all(participants_with_mission)
  end

  @doc """
  Marks a task as completed by a participant

  TODO::Documentation and verify user types
  """
  def give_task(%User{} = user, %User{} = staff, %Task{} = task) do
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

  ## Inserts
end
