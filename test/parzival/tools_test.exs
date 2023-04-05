defmodule Parzival.ToolsTest do
  use Parzival.DataCase

  alias Parzival.Tools

  describe "faq" do
    alias Parzival.Tools.Faq

    import Parzival.ToolsFixtures

    @invalid_attrs %{answer: nil, question: nil}

    test "list_faqs/0 returns all faq" do
      faq = faq_fixture()

      assert Tools.list_faqs([]) == [faq]
    end

    test "get_faq!/1 returns the faq with given id" do
      faq = faq_fixture()
      assert Tools.get_faq!(faq.id) == faq
    end

    test "create_faq/1 with valid data creates a faq" do
      valid_attrs = %{answer: "some answer", question: "some question"}

      assert {:ok, %Faq{} = faq} = Tools.create_faq(valid_attrs)
      assert faq.answer == "some answer"
      assert faq.question == "some question"
    end

    test "create_faq/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tools.create_faq(@invalid_attrs)
    end

    test "update_faq/2 with valid data updates the faq" do
      faq = faq_fixture()
      update_attrs = %{answer: "some updated answer", question: "some updated question"}

      assert {:ok, %Faq{} = faq} = Tools.update_faq(faq, update_attrs)
      assert faq.answer == "some updated answer"
      assert faq.question == "some updated question"
    end

    test "update_faq/2 with invalid data returns error changeset" do
      faq = faq_fixture()
      assert {:error, %Ecto.Changeset{}} = Tools.update_faq(faq, @invalid_attrs)
      assert faq == Tools.get_faq!(faq.id)
    end

    test "delete_faq/1 deletes the faq" do
      faq = faq_fixture()
      assert {:ok, %Faq{}} = Tools.delete_faq(faq)
      assert_raise Ecto.NoResultsError, fn -> Tools.get_faq!(faq.id) end
    end

    test "change_faq/1 returns a faq changeset" do
      faq = faq_fixture()
      assert %Ecto.Changeset{} = Tools.change_faq(faq)
    end
  end

  describe "announcements" do
    alias Parzival.Tools.Announcement

    import Parzival.ToolsFixtures

    @invalid_attrs %{text: nil, title: nil}

    test "list_announcements/0 returns all announcements" do
      announcement = announcement_fixture()

      assert Tools.list_announcements([]) == [announcement]
    end

    test "get_announcement!/1 returns the announcement with given id" do
      announcement = announcement_fixture()
      assert Tools.get_announcement!(announcement.id) == announcement
    end

    test "create_announcement/1 with valid data creates a announcement" do
      valid_attrs = %{
        text: "some text",
        title: "some title",
        author_id: Parzival.AccountsFixtures.user_fixture().id
      }

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

  describe "posts" do
    alias Parzival.Tools.Post

    import Parzival.ToolsFixtures

    @invalid_attrs %{text: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()

      assert Tools.list_posts([]) == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Tools.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{text: "some text", author_id: Parzival.AccountsFixtures.user_fixture().id}

      assert {:ok, %Post{} = post} = Tools.create_post(valid_attrs)
      assert post.text == "some text"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tools.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{text: "some updated text"}

      assert {:ok, %Post{} = post} = Tools.update_post(post, update_attrs)
      assert post.text == "some updated text"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Tools.update_post(post, @invalid_attrs)
      assert post == Tools.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Tools.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Tools.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Tools.change_post(post)
    end
  end
end
