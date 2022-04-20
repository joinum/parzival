defmodule ParzivalWeb.AnnouncementLiveTest do
  use ParzivalWeb.ConnCase

  import Phoenix.LiveViewTest
  import Parzival.ToolsFixtures

  @create_attrs %{text: "some text", title: "some title"}
  @update_attrs %{text: "some updated text", title: "some updated title"}
  @invalid_attrs %{text: nil, title: nil}

  defp create_announcement(_) do
    announcement = announcement_fixture()
    %{announcement: announcement}
  end

  describe "Index" do
    setup [:create_announcement]

    test "lists all announcements", %{conn: conn, announcement: announcement} do
      {:ok, _index_live, html} = live(conn, Routes.announcement_index_path(conn, :index))

      assert html =~ "Listing Announcements"
      assert html =~ announcement.text
    end

    test "saves new announcement", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.announcement_index_path(conn, :index))

      assert index_live |> element("a", "New Announcement") |> render_click() =~
               "New Announcement"

      assert_patch(index_live, Routes.announcement_index_path(conn, :new))

      assert index_live
             |> form("#announcement-form", announcement: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#announcement-form", announcement: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.announcement_index_path(conn, :index))

      assert html =~ "Announcement created successfully"
      assert html =~ "some text"
    end

    test "updates announcement in listing", %{conn: conn, announcement: announcement} do
      {:ok, index_live, _html} = live(conn, Routes.announcement_index_path(conn, :index))

      assert index_live |> element("#announcement-#{announcement.id} a", "Edit") |> render_click() =~
               "Edit Announcement"

      assert_patch(index_live, Routes.announcement_index_path(conn, :edit, announcement))

      assert index_live
             |> form("#announcement-form", announcement: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#announcement-form", announcement: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.announcement_index_path(conn, :index))

      assert html =~ "Announcement updated successfully"
      assert html =~ "some updated text"
    end

    test "deletes announcement in listing", %{conn: conn, announcement: announcement} do
      {:ok, index_live, _html} = live(conn, Routes.announcement_index_path(conn, :index))

      assert index_live
             |> element("#announcement-#{announcement.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#announcement-#{announcement.id}")
    end
  end

  describe "Show" do
    setup [:create_announcement]

    test "displays announcement", %{conn: conn, announcement: announcement} do
      {:ok, _show_live, html} =
        live(conn, Routes.announcement_show_path(conn, :show, announcement))

      assert html =~ "Show Announcement"
      assert html =~ announcement.text
    end

    test "updates announcement within modal", %{conn: conn, announcement: announcement} do
      {:ok, show_live, _html} =
        live(conn, Routes.announcement_show_path(conn, :show, announcement))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Announcement"

      assert_patch(show_live, Routes.announcement_show_path(conn, :edit, announcement))

      assert show_live
             |> form("#announcement-form", announcement: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#announcement-form", announcement: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.announcement_show_path(conn, :show, announcement))

      assert html =~ "Announcement updated successfully"
      assert html =~ "some updated text"
    end
  end
end
