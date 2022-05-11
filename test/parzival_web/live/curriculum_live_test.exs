defmodule ParzivalWeb.CurriculumLiveTest do
  use ParzivalWeb.ConnCase

  import Phoenix.LiveViewTest
  import Parzival.GamificationFixtures

  @create_attrs %{summary: "some summary"}
  @update_attrs %{summary: "some updated summary"}
  @invalid_attrs %{summary: nil}

  defp create_curriculum(_) do
    curriculum = curriculum_fixture()
    %{curriculum: curriculum}
  end

  describe "Index" do
    setup [:create_curriculum]

    test "lists all curriculums", %{conn: conn, curriculum: curriculum} do
      {:ok, _index_live, html} = live(conn, Routes.curriculum_index_path(conn, :index))

      assert html =~ "Listing Curriculums"
      assert html =~ curriculum.summary
    end

    test "saves new curriculum", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.curriculum_index_path(conn, :index))

      assert index_live |> element("a", "New Curriculum") |> render_click() =~
               "New Curriculum"

      assert_patch(index_live, Routes.curriculum_index_path(conn, :new))

      assert index_live
             |> form("#curriculum-form", curriculum: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#curriculum-form", curriculum: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.curriculum_index_path(conn, :index))

      assert html =~ "Curriculum created successfully"
      assert html =~ "some summary"
    end

    test "updates curriculum in listing", %{conn: conn, curriculum: curriculum} do
      {:ok, index_live, _html} = live(conn, Routes.curriculum_index_path(conn, :index))

      assert index_live |> element("#curriculum-#{curriculum.id} a", "Edit") |> render_click() =~
               "Edit Curriculum"

      assert_patch(index_live, Routes.curriculum_index_path(conn, :edit, curriculum))

      assert index_live
             |> form("#curriculum-form", curriculum: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#curriculum-form", curriculum: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.curriculum_index_path(conn, :index))

      assert html =~ "Curriculum updated successfully"
      assert html =~ "some updated summary"
    end

    test "deletes curriculum in listing", %{conn: conn, curriculum: curriculum} do
      {:ok, index_live, _html} = live(conn, Routes.curriculum_index_path(conn, :index))

      assert index_live |> element("#curriculum-#{curriculum.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#curriculum-#{curriculum.id}")
    end
  end

  describe "Show" do
    setup [:create_curriculum]

    test "displays curriculum", %{conn: conn, curriculum: curriculum} do
      {:ok, _show_live, html} = live(conn, Routes.curriculum_show_path(conn, :show, curriculum))

      assert html =~ "Show Curriculum"
      assert html =~ curriculum.summary
    end

    test "updates curriculum within modal", %{conn: conn, curriculum: curriculum} do
      {:ok, show_live, _html} = live(conn, Routes.curriculum_show_path(conn, :show, curriculum))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Curriculum"

      assert_patch(show_live, Routes.curriculum_show_path(conn, :edit, curriculum))

      assert show_live
             |> form("#curriculum-form", curriculum: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#curriculum-form", curriculum: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.curriculum_show_path(conn, :show, curriculum))

      assert html =~ "Curriculum updated successfully"
      assert html =~ "some updated summary"
    end
  end
end
