defmodule Parzival.MissionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  missions via the `Parzival.Missions` context.
  """

  def valid_mission_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      title: "Test",
      description: "Test mission"
    })
  end

  def valid_task_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      title: "Test Task",
      description: "Test Task"
    })
  end

  def mission_fixture(attrs \\ %{}) do
    {:ok, mission} =
      attrs
      |> valid_mission_attributes()
      |> Parzival.Missions.create_mission()

    mission
  end

  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> valid_task_attributes()
      |> Parzival.Missions.create_task()

    task
  end
end
