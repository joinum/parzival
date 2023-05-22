defmodule Parzival.GamificationTest do
  use Parzival.DataCase

  alias Parzival.Gamification

  @first_day_start Application.get_env(:parzival, :event)[:first_day_start]
  @first_day_end Application.get_env(:parzival, :event)[:first_day_end]
  @second_day_start Application.get_env(:parzival, :event)[:second_day_start]
  @second_day_end Application.get_env(:parzival, :event)[:second_day_end]
  @third_day_start Application.get_env(:parzival, :event)[:third_day_start]
  @third_day_end Application.get_env(:parzival, :event)[:third_day_end]

  describe "curriculums" do
    alias Parzival.Gamification.Curriculum

    @invalid_attrs %{summary: 123}

    test "list_curriculums/0 returns all curriculums" do
      curriculum = Parzival.AccountsFixtures.user_fixture().curriculum
      assert Gamification.list_curriculums() == [curriculum]
    end

    test "get_curriculum!/1 returns the curriculum with given id" do
      curriculum = Parzival.AccountsFixtures.user_fixture().curriculum
      assert Gamification.get_curriculum!(curriculum.id) == curriculum
    end

    test "create_curriculum/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gamification.create_curriculum(@invalid_attrs)
    end

    test "update_curriculum/2 with valid data updates the curriculum" do
      curriculum = Parzival.AccountsFixtures.user_fixture().curriculum
      update_attrs = %{summary: "some updated summary"}

      assert {:ok, %Curriculum{} = curriculum} =
               Gamification.update_curriculum(curriculum, update_attrs)

      assert curriculum.summary == "some updated summary"
    end

    test "update_curriculum/2 with invalid data returns error changeset" do
      curriculum = Parzival.AccountsFixtures.user_fixture().curriculum

      assert {:error, %Ecto.Changeset{}} =
               Gamification.update_curriculum(curriculum, @invalid_attrs)

      assert curriculum == Gamification.get_curriculum!(curriculum.id)
    end

    test "delete_curriculum/1 deletes the curriculum" do
      curriculum = Parzival.AccountsFixtures.user_fixture().curriculum
      assert {:ok, %Curriculum{}} = Gamification.delete_curriculum(curriculum)
      assert_raise Ecto.NoResultsError, fn -> Gamification.get_curriculum!(curriculum.id) end
    end

    test "change_curriculum/1 returns a curriculum changeset" do
      curriculum = Parzival.AccountsFixtures.user_fixture().curriculum
      assert %Ecto.Changeset{} = Gamification.change_curriculum(curriculum)
    end
  end

  describe "missions" do
    alias Parzival.Gamification.Mission
    alias Parzival.Repo

    import Parzival.AccountsFixtures
    import Parzival.GamificationFixtures

    test "redeem_task/3 single task" do
      attendee = user_fixture()
      staff = user_fixture(%{role: :staff})

      mission =
        mission_fixture(2)
        |> Repo.preload(:tasks)

      task0 = Enum.at(mission.tasks, 0)
      task1 = Enum.at(mission.tasks, 1)

      assert {:ok, updated = %Mission{}} = Gamification.redeem_task(attendee, task0, staff)

      assert attendee.id in Enum.map(Repo.preload(task0, :users).users, fn u -> u.id end)
      assert attendee.id not in Enum.map(Repo.preload(task1, :users).users, fn u -> u.id end)
      assert attendee.id not in Enum.map(Repo.preload(updated, :users).users, fn u -> u.id end)

      assert Parzival.Accounts.get_user!(attendee.id).balance == task0.tokens
      assert Parzival.Accounts.get_user!(attendee.id).exp == task0.exp
    end

    test "redeem_task/3 all tasks" do
      attendee = user_fixture()
      staff = user_fixture(%{role: :staff})

      mission =
        mission_fixture(2)
        |> Repo.preload(:tasks)

      task0 = Enum.at(mission.tasks, 0)
      task1 = Enum.at(mission.tasks, 1)

      assert {:ok, %Mission{}} = Gamification.redeem_task(attendee, task0, staff)
      attendee = Parzival.Accounts.get_user!(attendee.id)
      assert {:ok, mission = %Mission{}} = Gamification.redeem_task(attendee, task1, staff)
      attendee = Parzival.Accounts.get_user!(attendee.id)

      assert attendee.id in Enum.map(Repo.preload(task0, :users).users, fn u -> u.id end)
      assert attendee.id in Enum.map(Repo.preload(task1, :users).users, fn u -> u.id end)
      assert attendee.id in Enum.map(Repo.preload(mission, :users).users, fn u -> u.id end)

      assert attendee.balance == task0.tokens + task1.tokens + mission.tokens
      assert attendee.exp == task0.exp + task1.exp + mission.exp
    end

    test "get_exp/3 returns the exp of the given user on a specific day" do
      start_time = DateTime.utc_now()
      end_time = DateTime.utc_now() |> DateTime.add(3600 * 2, :second)
      # IO.puts("start_time is #{start_time}")
      # IO.puts("end_time is #{end_time}")

      attendee = user_fixture()
      staff = user_fixture(%{role: :staff})

      mission =
        mission_fixture(2)
        |> Repo.preload(:tasks)

      task0 = Enum.at(mission.tasks, 0)
      task1 = Enum.at(mission.tasks, 1)


      assert {:ok, %Mission{}} = Gamification.redeem_task(attendee, task0, staff)

      assert Gamification.get_exp(attendee, start_time, end_time) == task0.exp

      assert {:ok, %Mission{}} = Gamification.redeem_task(attendee, task1, staff)

      assert Gamification.get_exp(attendee, start_time, end_time) == task0.exp + task1.exp + mission.exp
    end

    test "get_leaderboard/2 returns the leaderboard for given dates" do
      start_time = DateTime.utc_now()
      end_time = DateTime.utc_now() |> DateTime.add(3600 * 2, :second)

      attendee_1 = user_fixture()
      attendee_2 = user_fixture()
      attendee_3 = user_fixture()
      staff = user_fixture(%{role: :staff})

      mission =
        mission_fixture(3)
        |> Repo.preload(:tasks)

      task0 = Enum.at(mission.tasks, 0)
      task1 = Enum.at(mission.tasks, 1)
      task2 = Enum.at(mission.tasks, 2)

      assert {:ok, %Mission{}} = Gamification.redeem_task(attendee_1, task0, staff)
      assert {:ok, %Mission{}} = Gamification.redeem_task(attendee_1, task1, staff)
      assert {:ok, %Mission{}} = Gamification.redeem_task(attendee_1, task2, staff)

      assert {:ok, %Mission{}} = Gamification.redeem_task(attendee_2, task0, staff)
      assert {:ok, %Mission{}} = Gamification.redeem_task(attendee_2, task1, staff)

      assert {:ok, %Mission{}} = Gamification.redeem_task(attendee_3, task0, staff)

      leaderboard = Gamification.get_leaderboard(start_time, end_time)

      assert Enum.at(leaderboard, 0).user == attendee_1.id
      assert Enum.at(leaderboard, 0).experience == task0.exp + task1.exp + task2.exp + mission.exp

      assert Enum.at(leaderboard, 1).user == attendee_2.id
      assert Enum.at(leaderboard, 1).experience == task0.exp + task1.exp

      assert Enum.at(leaderboard, 2).user == attendee_3.id
      assert Enum.at(leaderboard, 2).experience == task0.exp
    end
  end
end
