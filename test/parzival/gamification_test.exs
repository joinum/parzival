defmodule Parzival.GamificationTest do
  use Parzival.DataCase

  alias Parzival.Gamification

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

    test "get_exp/2 returns the exp of the given user on a specific day" do
      attendee = user_fixture()
      staff = user_fixture(%{role: :staff})

      mission =
        mission_fixture(2)
        |> Repo.preload(:tasks)

      task0 = Enum.at(mission.tasks, 0)
      task1 = Enum.at(mission.tasks, 1)

      assert {:ok, %Mission{}} = Gamification.redeem_task(attendee, task0, staff)

      assert Gamification.get_exp(attendee, 3) == task0.exp
      IO.puts "task0.exp: #{task0.exp} + task1.exp: #{task1.exp} + mission.exp: #{mission.exp}"
      IO.puts "exp: #{Gamification.get_exp(attendee, 3)}"

      assert {:ok, mission = %Mission{}} = Gamification.redeem_task(attendee, task1, staff)

      assert Gamification.get_exp(attendee, 3) == task0.exp + task1.exp + mission.exp
    end
  end
end
