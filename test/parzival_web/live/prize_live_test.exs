defmodule ParzivalWeb.OrderLiveTest do
  use ParzivalWeb.ConnCase

  import Phoenix.LiveViewTest
  import Parzival.StoreFixtures

  @create_attrs %{quantity: 42, redeemed: 42}
  @update_attrs %{quantity: 43, redeemed: 43}
  @invalid_attrs %{quantity: nil, redeemed: nil}

  defp create_order(_) do
    order = order_fixture()
    %{order: order}
  end

  describe "Index" do
    setup [:create_order]

    test "lists all orders", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.order_index_path(conn, :index))

      assert html =~ "Listing orders"
    end

    test "saves new order", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.order_index_path(conn, :index))

      assert index_live |> element("a", "New order") |> render_click() =~
               "New order"

      assert_patch(index_live, Routes.order_index_path(conn, :new))

      assert index_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#order-form", order: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.order_index_path(conn, :index))

      assert html =~ "order created successfully"
    end

    test "updates order in listing", %{conn: conn, order: order} do
      {:ok, index_live, _html} = live(conn, Routes.order_index_path(conn, :index))

      assert index_live |> element("#order-#{order.id} a", "Edit") |> render_click() =~
               "Edit order"

      assert_patch(index_live, Routes.order_index_path(conn, :edit, order))

      assert index_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#order-form", order: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.order_index_path(conn, :index))

      assert html =~ "order updated successfully"
    end

    test "deletes order in listing", %{conn: conn, order: order} do
      {:ok, index_live, _html} = live(conn, Routes.order_index_path(conn, :index))

      assert index_live |> element("#order-#{order.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#order-#{order.id}")
    end
  end

  describe "Show" do
    setup [:create_order]

    test "displays order", %{conn: conn, order: order} do
      {:ok, _show_live, html} = live(conn, Routes.order_show_path(conn, :show, order))

      assert html =~ "Show order"
    end

    test "updates order within modal", %{conn: conn, order: order} do
      {:ok, show_live, _html} = live(conn, Routes.order_show_path(conn, :show, order))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit order"

      assert_patch(show_live, Routes.order_show_path(conn, :edit, order))

      assert show_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#order-form", order: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.order_show_path(conn, :show, order))

      assert html =~ "order updated successfully"
    end
  end
end
