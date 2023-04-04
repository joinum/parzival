defmodule Parzival.GamificationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Parzival.Gamification` context.
  """
  alias Parzival.Gamification

  @doc """
  Generate a curriculum.
  """
  def curriculum_fixture(attrs \\ %{}) do
    {:ok, curriculum} =
      attrs
      |> Enum.into(%{
        user_id: Parzival.AccountsFixtures.user_fixture().id,
        summary: "some summary"
      })
      |> Parzival.Gamification.create_curriculum()

    curriculum
  end

  @doc """
  Generate a task.
  Number of tokens and exp is random if not specified.
  attrs must contain mission_id
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        title: "A task",
        description: "A cool task",
        tokens: Enum.random(1..500),
        exp: Enum.random(1..500)
      })
      |> Gamification.create_task()

    task
  end

  @doc """
  Generate a mission with the specified number of tasks
  """
  def mission_fixture(task_no, attrs \\ %{}) do
    {:ok, difficulty} =
      %{name: "Uma dificuldade", color: "red"}
      |> Gamification.create_difficulty()

    {:ok, mission} =
      attrs
      |> Enum.into(%{
        title: "A mission",
        description: "A cool description",
        exp: 321,
        level: 3,
        tokens: 123,
        difficulty_id: difficulty.id
      })
      |> Gamification.create_mission()

    Enum.each(1..task_no, fn _ ->
      task_fixture(%{mission_id: mission.id})
    end)

    mission
  end
end
