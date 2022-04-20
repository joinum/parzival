defmodule Parzival.ToolsTest do
  use Parzival.DataCase

  alias Parzival.Tools

  describe "faqs" do
    alias Parzival.Tools.Faqs

    import Parzival.ToolsFixtures

    @invalid_attrs %{answer: nil, question: nil}

    test "list_faqs/0 returns all faqs" do
      faqs = faqs_fixture()
      assert Tools.list_faqs() == [faqs]
    end

    test "get_faqs!/1 returns the faqs with given id" do
      faqs = faqs_fixture()
      assert Tools.get_faqs!(faqs.id) == faqs
    end

    test "create_faqs/1 with valid data creates a faqs" do
      valid_attrs = %{answer: "some answer", question: "some question"}

      assert {:ok, %Faqs{} = faqs} = Tools.create_faqs(valid_attrs)
      assert faqs.answer == "some answer"
      assert faqs.question == "some question"
    end

    test "create_faqs/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tools.create_faqs(@invalid_attrs)
    end

    test "update_faqs/2 with valid data updates the faqs" do
      faqs = faqs_fixture()
      update_attrs = %{answer: "some updated answer", question: "some updated question"}

      assert {:ok, %Faqs{} = faqs} = Tools.update_faqs(faqs, update_attrs)
      assert faqs.answer == "some updated answer"
      assert faqs.question == "some updated question"
    end

    test "update_faqs/2 with invalid data returns error changeset" do
      faqs = faqs_fixture()
      assert {:error, %Ecto.Changeset{}} = Tools.update_faqs(faqs, @invalid_attrs)
      assert faqs == Tools.get_faqs!(faqs.id)
    end

    test "delete_faqs/1 deletes the faqs" do
      faqs = faqs_fixture()
      assert {:ok, %Faqs{}} = Tools.delete_faqs(faqs)
      assert_raise Ecto.NoResultsError, fn -> Tools.get_faqs!(faqs.id) end
    end

    test "change_faqs/1 returns a faqs changeset" do
      faqs = faqs_fixture()
      assert %Ecto.Changeset{} = Tools.change_faqs(faqs)
    end
  end

  describe "announcements" do
    alias Parzival.Tools.Announcement

    import Parzival.ToolsFixtures

    @invalid_attrs %{text: nil, title: nil}

    test "list_announcements/0 returns all announcements" do
      announcement = announcement_fixture()
      assert Tools.list_announcements() == [announcement]
    end

    test "get_announcement!/1 returns the announcement with given id" do
      announcement = announcement_fixture()
      assert Tools.get_announcement!(announcement.id) == announcement
    end

    test "create_announcement/1 with valid data creates a announcement" do
      valid_attrs = %{text: "some text", title: "some title"}

      assert {:ok, %Announcement{} = announcement} = Tools.create_announcement(valid_attrs)
      assert announcement.text == "some text"
      assert announcement.title == "some title"
    end

    test "create_announcement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tools.create_announcement(@invalid_attrs)
    end

    test "update_announcement/2 with valid data updates the announcement" do
      announcement = announcement_fixture()
      update_attrs = %{text: "some updated text", title: "some updated title"}

      assert {:ok, %Announcement{} = announcement} =
               Tools.update_announcement(announcement, update_attrs)

      assert announcement.text == "some updated text"
      assert announcement.title == "some updated title"
    end

    test "update_announcement/2 with invalid data returns error changeset" do
      announcement = announcement_fixture()
      assert {:error, %Ecto.Changeset{}} = Tools.update_announcement(announcement, @invalid_attrs)
      assert announcement == Tools.get_announcement!(announcement.id)
    end

    test "delete_announcement/1 deletes the announcement" do
      announcement = announcement_fixture()
      assert {:ok, %Announcement{}} = Tools.delete_announcement(announcement)
      assert_raise Ecto.NoResultsError, fn -> Tools.get_announcement!(announcement.id) end
    end

    test "change_announcement/1 returns a announcement changeset" do
      announcement = announcement_fixture()
      assert %Ecto.Changeset{} = Tools.change_announcement(announcement)
    end
  end
end
