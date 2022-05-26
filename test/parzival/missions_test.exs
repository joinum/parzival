defmodule Parzival.MissionsTest do
  use Parzival.DataCase

  alias Parzival.Missions

  import Parzival.MissionsFixtures
  import Ecto

  alias Parzival.Accounts.User
  alias Parzival.Missions.{Mission, Task, TaskCompletion}

  describe "get_mission/1" do
    test "does not return the mission if the mission does not exits" do
      refute Missions.get_mission!(Ecto.UUID.generate())
    end

    test "returns the mission if it exists" do
      %{id: id} = mission = mission_fixture()
      assert %Mission{id: id} = Missions.get_mission!(mission.id)
    end
  end

  describe "get_task/1" do
    test "does not return the task if the task does not exits" do
      refute Missions.get_task!(Ecto.UUID.generate())
    end

    test "returns the task if it exists" do
      %{id: id} = task = task_fixture()
      assert %Task{id: ^id} = Missions.get_task!(task.id)
    end
  end

  describe "get_tasks_of_mission/1" do
    test "does not return the tasks if the mission does not exits" do
      refute Missions.get_tasks_of_mission!(Ecto.UUID.generate())
    end

    test "returns the task if it exists" do
      %{id: id} = mission = mission_fixture()
      assert nil == Missions.get_tasks_of_mission!(mission.id)
    end
  end

  describe "get_participants_with_mission/1" do
    test "returns a participant with the mission" do
      %{mission_id: mission_id, user_id: user_id} = mission_tasks_user_fixture()
      [user] = Missions.get_participants_with_mission!(mission_id)
      assert user_id == user.id
    end
  end

  describe "get_missions_of_participant/1" do
    test "returns all the missions completed by a participant" do
      %{mission_id: mission_id, user_id: user_id} = mission_tasks_user_fixture()
      [mission] = Missions.get_missions_of_participant!(user_id)
      assert mission_id == mission.id
    end
  end

  describe "get_participants_with_task/1" do
    test "returns a participant with the task" do
      %{task_id: task_id, user_id: user_id} = mission_tasks_user_fixture()
      [user] = Missions.get_participants_with_task!(task_id)
      assert user_id == user.id
    end
  end
end
