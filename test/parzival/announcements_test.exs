defmodule Parzival.AnnouncementsTest do

  use Parzival.DataCase

  alias Parzival.Tools
  alias Parzival.Announcements
  describe "announcements" do
    alias Parzival.Announcements.Announcement

    import Parzival.ToolsFixtures

    @update_attrs %{city: "Vizela", mobile: "934568701"}
    @invalid_attrs %{city: "Guimarães", mobile: nil}

    def valid_announcement do
      %{
        title: "JOIN 2022",
        content: "Abertura",
      }
    end

    @update_attrs %{title: "JOIN deste ano", mobile: "Abertura terminou"}

    def attrs do
      announcement = valid_announcement()
      new_announcement = Announcement.create_announcement(announcement)
      announcement_id = elem(new_announcement, 1).id
      Map.put(announcement, :announcement_id, announcement_id)
    end

    def announcement_fixture(atributes \\ %{}) do
      valid_announcement = valid_announcement()

      {:ok, announcement} =
        atributes
        |> Enum.into(valid_announcement)
        |> Announcements.create_announcement()

      announcement
    end

    test "list_announcements/0 returns all announcements" do
      announcement = announcement_fixture()
      assert Announcements.list_announcements() == [announcement]
    end

    test "get_announcement!/1 returns the announcement with given id" do
      announcement = announcement_fixture()
      assert Announcements.get_announcement!(announcement.id) == announcement
    end

    test "create_announcement/1 with valid data creates a announcement" do
      announcement = valid_announcement()
      assert {:ok, %Announcement{} = announcement} = Announcements.create_announcement(attrs)
      assert announcement.title == "JOIN 2022"
      assert announcement.mobile == "Abertura"
    end

    test "update_announcement/2 with valid data updates the announcement" do
      announcement = announcement_fixture()
      assert {:ok, %Announcement{} = announcement} = Announcements.update_announcement(announcement, @update_attrs)
      assert announcement.title == "JOIN deste ano"
      assert announcement.content == "Abertura terminou"
    end

    test "delete_announcement/1 deletes the announcement" do
      announcement = announcement_fixture()
      assert {:ok, %Announcement{}} = Announcements.delete_announcement(announcement)
      assert_raise Ecto.NoResultsError, fn -> Announcements.get_announcement!(announcement.id) end
    end

    test "change_announcement/1 returns a announcement changeset" do
      announcement = announcement_fixture()
      assert %Ecto.Changeset{} = Announcements.change_announcement(announcement)
    end
  end
end
