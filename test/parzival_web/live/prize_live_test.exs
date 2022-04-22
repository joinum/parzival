defmodule ParzivalWeb.PrizeLiveTest do
  use ParzivalWeb.ConnCase

  import Phoenix.LiveViewTest
  import Parzival.StoreFixtures

  @create_attrs %{quantity: 42, redeemed: 42}
  @update_attrs %{quantity: 43, redeemed: 43}
  @invalid_attrs %{quantity: nil, redeemed: nil}

  defp create_prize(_) do
    prize = prize_fixture()
    %{prize: prize}
  end

  describe "Index" do
    setup [:create_prize]

    test "lists all prizes", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.prize_index_path(conn, :index))

      assert html =~ "Listing Prizes"
    end

    test "saves new prize", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.prize_index_path(conn, :index))

      assert index_live |> element("a", "New Prize") |> render_click() =~
               "New Prize"

      assert_patch(index_live, Routes.prize_index_path(conn, :new))

      assert index_live
             |> form("#prize-form", prize: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#prize-form", prize: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.prize_index_path(conn, :index))

      assert html =~ "Prize created successfully"
    end

    test "updates prize in listing", %{conn: conn, prize: prize} do
      {:ok, index_live, _html} = live(conn, Routes.prize_index_path(conn, :index))

      assert index_live |> element("#prize-#{prize.id} a", "Edit") |> render_click() =~
               "Edit Prize"

      assert_patch(index_live, Routes.prize_index_path(conn, :edit, prize))

      assert index_live
             |> form("#prize-form", prize: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#prize-form", prize: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.prize_index_path(conn, :index))

      assert html =~ "Prize updated successfully"
    end

    test "deletes prize in listing", %{conn: conn, prize: prize} do
      {:ok, index_live, _html} = live(conn, Routes.prize_index_path(conn, :index))

      assert index_live |> element("#prize-#{prize.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#prize-#{prize.id}")
    end
  end

  describe "Show" do
    setup [:create_prize]

    test "displays prize", %{conn: conn, prize: prize} do
      {:ok, _show_live, html} = live(conn, Routes.prize_show_path(conn, :show, prize))

      assert html =~ "Show Prize"
    end

    test "updates prize within modal", %{conn: conn, prize: prize} do
      {:ok, show_live, _html} = live(conn, Routes.prize_show_path(conn, :show, prize))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Prize"

      assert_patch(show_live, Routes.prize_show_path(conn, :edit, prize))

      assert show_live
             |> form("#prize-form", prize: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#prize-form", prize: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.prize_show_path(conn, :show, prize))

      assert html =~ "Prize updated successfully"
    end
  end
end
