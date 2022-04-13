defmodule ParzivalWeb.FaqsLiveTest do
  use ParzivalWeb.ConnCase

  import Phoenix.LiveViewTest
  import Parzival.ToolsFixtures

  @create_attrs %{answer: "some answer", question: "some question"}
  @update_attrs %{answer: "some updated answer", question: "some updated question"}
  @invalid_attrs %{answer: nil, question: nil}

  defp create_faqs(_) do
    faqs = faqs_fixture()
    %{faqs: faqs}
  end

  describe "Index" do
    setup [:create_faqs]

    test "lists all faqs", %{conn: conn, faqs: faqs} do
      {:ok, _index_live, html} = live(conn, Routes.faqs_index_path(conn, :index))

      assert html =~ "Listing Faqs"
      assert html =~ faqs.answer
    end

    test "saves new faqs", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.faqs_index_path(conn, :index))

      assert index_live |> element("a", "New Faqs") |> render_click() =~
               "New Faqs"

      assert_patch(index_live, Routes.faqs_index_path(conn, :new))

      assert index_live
             |> form("#faqs-form", faqs: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#faqs-form", faqs: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.faqs_index_path(conn, :index))

      assert html =~ "Faqs created successfully"
      assert html =~ "some answer"
    end

    test "updates faqs in listing", %{conn: conn, faqs: faqs} do
      {:ok, index_live, _html} = live(conn, Routes.faqs_index_path(conn, :index))

      assert index_live |> element("#faqs-#{faqs.id} a", "Edit") |> render_click() =~
               "Edit Faqs"

      assert_patch(index_live, Routes.faqs_index_path(conn, :edit, faqs))

      assert index_live
             |> form("#faqs-form", faqs: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#faqs-form", faqs: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.faqs_index_path(conn, :index))

      assert html =~ "Faqs updated successfully"
      assert html =~ "some updated answer"
    end

    test "deletes faqs in listing", %{conn: conn, faqs: faqs} do
      {:ok, index_live, _html} = live(conn, Routes.faqs_index_path(conn, :index))

      assert index_live |> element("#faqs-#{faqs.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#faqs-#{faqs.id}")
    end
  end

  describe "Show" do
    setup [:create_faqs]

    test "displays faqs", %{conn: conn, faqs: faqs} do
      {:ok, _show_live, html} = live(conn, Routes.faqs_show_path(conn, :show, faqs))

      assert html =~ "Show Faqs"
      assert html =~ faqs.answer
    end

    test "updates faqs within modal", %{conn: conn, faqs: faqs} do
      {:ok, show_live, _html} = live(conn, Routes.faqs_show_path(conn, :show, faqs))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Faqs"

      assert_patch(show_live, Routes.faqs_show_path(conn, :edit, faqs))

      assert show_live
             |> form("#faqs-form", faqs: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#faqs-form", faqs: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.faqs_show_path(conn, :show, faqs))

      assert html =~ "Faqs updated successfully"
      assert html =~ "some updated answer"
    end
  end
end
