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
end
