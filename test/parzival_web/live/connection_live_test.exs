defmodule ParzivalWeb.ConnectionLiveTest do
  use ParzivalWeb.ConnCase

  import Phoenix.LiveViewTest
  import Parzival.CompaniesFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_connection(_) do
    connection = connection_fixture()
    %{connection: connection}
  end

  describe "Index" do
    setup [:create_connection]

    test "lists all connections", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.connection_index_path(conn, :index))

      assert html =~ "Listing Connections"
    end

    test "saves new connection", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.connection_index_path(conn, :index))

      assert index_live |> element("a", "New Connection") |> render_click() =~
               "New Connection"

      assert_patch(index_live, Routes.connection_index_path(conn, :new))

      assert index_live
             |> form("#connection-form", connection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#connection-form", connection: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.connection_index_path(conn, :index))

      assert html =~ "Connection created successfully"
    end

    test "updates connection in listing", %{conn: conn, connection: connection} do
      {:ok, index_live, _html} = live(conn, Routes.connection_index_path(conn, :index))

      assert index_live |> element("#connection-#{connection.id} a", "Edit") |> render_click() =~
               "Edit Connection"

      assert_patch(index_live, Routes.connection_index_path(conn, :edit, connection))

      assert index_live
             |> form("#connection-form", connection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#connection-form", connection: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.connection_index_path(conn, :index))

      assert html =~ "Connection updated successfully"
    end

    test "deletes connection in listing", %{conn: conn, connection: connection} do
      {:ok, index_live, _html} = live(conn, Routes.connection_index_path(conn, :index))

      assert index_live |> element("#connection-#{connection.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#connection-#{connection.id}")
    end
  end

  describe "Show" do
    setup [:create_connection]

    test "displays connection", %{conn: conn, connection: connection} do
      {:ok, _show_live, html} = live(conn, Routes.connection_show_path(conn, :show, connection))

      assert html =~ "Show Connection"
    end

    test "updates connection within modal", %{conn: conn, connection: connection} do
      {:ok, show_live, _html} = live(conn, Routes.connection_show_path(conn, :show, connection))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Connection"

      assert_patch(show_live, Routes.connection_show_path(conn, :edit, connection))

      assert show_live
             |> form("#connection-form", connection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#connection-form", connection: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.connection_show_path(conn, :show, connection))

      assert html =~ "Connection updated successfully"
    end
  end
end
