defmodule Parzival.Missions do
  @moduledoc """
  The Missions context.
  """
  use Parzival.Context

  import Ecto.Query, warn: false

  alias Parzival.Missions.*
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

  def list_task_completions(params \\ %{})

  def list_task_completions(opts) when is_list(opts) do
    Task_Completion
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_task_completions(flop) do
    Flop.validate_and_run(Task_Completion, flop, for: Task_Completion)
  end

  def list_task_completions(%{} = flop, opts) when is_list(opts) do
    Task_Completion
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Task_Completion)
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
  def get_mission!(id), do: Repo.get!(Mission, id)

  @doc """
  Gets a single Task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

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
    Mission
    |> where([m], subquery(
      Task
      |> where([t], subquery(
        Task_Completion
        |> where([tc], tc.participant_id == participant_id && tc.task_id == t.id)
        |> Repo.exists
      ) && t.mission_id == mission_id)
      |> Repo.aggregate(:count, :mission_id)
    )
      ==
      subquery(Task_Completion
      |> where([p], p.mission_id == m.id)
      |> Repo.aggregate(:count, :mission_id)))
    |> Repo.all
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
    Participant
    |> where([p], subquery(
      Task
      |> where([t], subquery(
        Task_Completion
        |> where([tc], tc.participant_id == p.id && tc.task_id == t.id)
        |> Repo.exists
      ) && t.mission_id == mission_id)
      |> Repo.aggregate(:count, :mission_id)
    )
      ==
      subquery(Task
      |> where([p], p.mission_id == mission_id)
      |> Repo.aggregate(:count, :mission_id)))
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
    Participant
    |> where([p], subquery(
      Task_Completion
      |> where([p], p.task_id == task_id && p.participant_id == p.id)
      |> Repo.exists
    )
    |> Repo.all
  end

  @doc """
  Marks a task as completed by a participant

  TODO::Documentation
  """
  def give_task(%User{} = user, %User{} staff, %Task{} = task) do
    %Task_Completion{participant: user, staff: staff, task: task}
    |> Repo.insert
  end

  ## Inserts
end
