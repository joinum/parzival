defmodule ParzivalWeb.OfferTimeLiveTest do
  use ParzivalWeb.ConnCase

  import Phoenix.LiveViewTest
  import Parzival.CompaniesFixtures

  @create_attrs %{color: "some color", name: "some name"}
  @update_attrs %{color: "some updated color", name: "some updated name"}
  @invalid_attrs %{color: nil, name: nil}

  defp create_offer_time(_) do
    offer_time = offer_time_fixture()
    %{offer_time: offer_time}
  end

  describe "Index" do
    setup [:create_offer_time]

    test "lists all offer_times", %{conn: conn, offer_time: offer_time} do
      {:ok, _index_live, html} = live(conn, Routes.offer_time_index_path(conn, :index))

      assert html =~ "Listing Offer times"
      assert html =~ offer_time.color
    end

    test "saves new offer_time", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.offer_time_index_path(conn, :index))

      assert index_live |> element("a", "New Offer time") |> render_click() =~
               "New Offer time"

      assert_patch(index_live, Routes.offer_time_index_path(conn, :new))

      assert index_live
             |> form("#offer_time-form", offer_time: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#offer_time-form", offer_time: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.offer_time_index_path(conn, :index))

      assert html =~ "Offer time created successfully"
      assert html =~ "some color"
    end

    test "updates offer_time in listing", %{conn: conn, offer_time: offer_time} do
      {:ok, index_live, _html} = live(conn, Routes.offer_time_index_path(conn, :index))

      assert index_live |> element("#offer_time-#{offer_time.id} a", "Edit") |> render_click() =~
               "Edit Offer time"

      assert_patch(index_live, Routes.offer_time_index_path(conn, :edit, offer_time))

      assert index_live
             |> form("#offer_time-form", offer_time: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#offer_time-form", offer_time: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.offer_time_index_path(conn, :index))

      assert html =~ "Offer time updated successfully"
      assert html =~ "some updated color"
    end

    test "deletes offer_time in listing", %{conn: conn, offer_time: offer_time} do
      {:ok, index_live, _html} = live(conn, Routes.offer_time_index_path(conn, :index))

      assert index_live |> element("#offer_time-#{offer_time.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#offer_time-#{offer_time.id}")
    end
  end

  describe "Show" do
    setup [:create_offer_time]

    test "displays offer_time", %{conn: conn, offer_time: offer_time} do
      {:ok, _show_live, html} = live(conn, Routes.offer_time_show_path(conn, :show, offer_time))

      assert html =~ "Show Offer time"
      assert html =~ offer_time.color
    end

    test "updates offer_time within modal", %{conn: conn, offer_time: offer_time} do
      {:ok, show_live, _html} = live(conn, Routes.offer_time_show_path(conn, :show, offer_time))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Offer time"

      assert_patch(show_live, Routes.offer_time_show_path(conn, :edit, offer_time))

      assert show_live
             |> form("#offer_time-form", offer_time: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#offer_time-form", offer_time: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.offer_time_show_path(conn, :show, offer_time))

      assert html =~ "Offer time updated successfully"
      assert html =~ "some updated color"
    end
  end
end
