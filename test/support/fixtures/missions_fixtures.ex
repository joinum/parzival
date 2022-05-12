defmodule Parzival.MissionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  missions via the `Parzival.Missions` context.
  """
  alias Parzival.Repo

  def valid_mission_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      title: "Test",
      description: "Test mission"
    })
  end

  def valid_task_attributes(attrs \\ %{}) do
    %{id: id} = mission_fixture()
    Enum.into(attrs, %{
      title: "Test Task",
      description: "Test Task",
      start_time: "2022-10-20 10:34:02",
      end_time: "2022-10-20 10:34:02",
      mission_id: id
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
