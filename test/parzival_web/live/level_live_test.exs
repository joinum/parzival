defmodule ParzivalWeb.LevelLiveTest do
  use ParzivalWeb.ConnCase

  import Phoenix.LiveViewTest
  import Parzival.CompaniesFixtures

  @create_attrs %{color: "some color", name: "some name"}
  @update_attrs %{color: "some updated color", name: "some updated name"}
  @invalid_attrs %{color: nil, name: nil}

  defp create_level(_) do
    level = level_fixture()
    %{level: level}
  end

  describe "Index" do
    setup [:create_level]

    test "lists all levels", %{conn: conn, level: level} do
      {:ok, _index_live, html} = live(conn, Routes.level_index_path(conn, :index))

      assert html =~ "Listing Levels"
      assert html =~ level.color
    end

    test "saves new level", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.level_index_path(conn, :index))

      assert index_live |> element("a", "New Level") |> render_click() =~
               "New Level"

      assert_patch(index_live, Routes.level_index_path(conn, :new))

      assert index_live
             |> form("#level-form", level: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#level-form", level: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.level_index_path(conn, :index))

      assert html =~ "Level created successfully"
      assert html =~ "some color"
    end

    test "updates level in listing", %{conn: conn, level: level} do
      {:ok, index_live, _html} = live(conn, Routes.level_index_path(conn, :index))

      assert index_live |> element("#level-#{level.id} a", "Edit") |> render_click() =~
               "Edit Level"

      assert_patch(index_live, Routes.level_index_path(conn, :edit, level))

      assert index_live
             |> form("#level-form", level: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#level-form", level: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.level_index_path(conn, :index))

      assert html =~ "Level updated successfully"
      assert html =~ "some updated color"
    end

    test "deletes level in listing", %{conn: conn, level: level} do
      {:ok, index_live, _html} = live(conn, Routes.level_index_path(conn, :index))

      assert index_live |> element("#level-#{level.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#level-#{level.id}")
    end
  end

  describe "Show" do
    setup [:create_level]

    test "displays level", %{conn: conn, level: level} do
      {:ok, _show_live, html} = live(conn, Routes.level_show_path(conn, :show, level))

      assert html =~ "Show Level"
      assert html =~ level.color
    end

    test "updates level within modal", %{conn: conn, level: level} do
      {:ok, show_live, _html} = live(conn, Routes.level_show_path(conn, :show, level))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Level"

      assert_patch(show_live, Routes.level_show_path(conn, :edit, level))

      assert show_live
             |> form("#level-form", level: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#level-form", level: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.level_show_path(conn, :show, level))

      assert html =~ "Level updated successfully"
      assert html =~ "some updated color"
    end
  end
end
