defmodule ParzivalWeb.OfferTypeLiveTest do
  use ParzivalWeb.ConnCase

  import Phoenix.LiveViewTest
  import Parzival.CompaniesFixtures

  @create_attrs %{color: "some color", name: "some name"}
  @update_attrs %{color: "some updated color", name: "some updated name"}
  @invalid_attrs %{color: nil, name: nil}

  defp create_offer_type(_) do
    offer_type = offer_type_fixture()
    %{offer_type: offer_type}
  end

  describe "Index" do
    setup [:create_offer_type]

    test "lists all offer_types", %{conn: conn, offer_type: offer_type} do
      {:ok, _index_live, html} = live(conn, Routes.offer_type_index_path(conn, :index))

      assert html =~ "Listing Offer types"
      assert html =~ offer_type.color
    end

    test "saves new offer_type", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.offer_type_index_path(conn, :index))

      assert index_live |> element("a", "New Offer type") |> render_click() =~
               "New Offer type"

      assert_patch(index_live, Routes.offer_type_index_path(conn, :new))

      assert index_live
             |> form("#offer_type-form", offer_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#offer_type-form", offer_type: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.offer_type_index_path(conn, :index))

      assert html =~ "Offer type created successfully"
      assert html =~ "some color"
    end

    test "updates offer_type in listing", %{conn: conn, offer_type: offer_type} do
      {:ok, index_live, _html} = live(conn, Routes.offer_type_index_path(conn, :index))

      assert index_live |> element("#offer_type-#{offer_type.id} a", "Edit") |> render_click() =~
               "Edit Offer type"

      assert_patch(index_live, Routes.offer_type_index_path(conn, :edit, offer_type))

      assert index_live
             |> form("#offer_type-form", offer_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#offer_type-form", offer_type: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.offer_type_index_path(conn, :index))

      assert html =~ "Offer type updated successfully"
      assert html =~ "some updated color"
    end

    test "deletes offer_type in listing", %{conn: conn, offer_type: offer_type} do
      {:ok, index_live, _html} = live(conn, Routes.offer_type_index_path(conn, :index))

      assert index_live |> element("#offer_type-#{offer_type.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#offer_type-#{offer_type.id}")
    end
  end

  describe "Show" do
    setup [:create_offer_type]

    test "displays offer_type", %{conn: conn, offer_type: offer_type} do
      {:ok, _show_live, html} = live(conn, Routes.offer_type_show_path(conn, :show, offer_type))

      assert html =~ "Show Offer type"
      assert html =~ offer_type.color
    end

    test "updates offer_type within modal", %{conn: conn, offer_type: offer_type} do
      {:ok, show_live, _html} = live(conn, Routes.offer_type_show_path(conn, :show, offer_type))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Offer type"

      assert_patch(show_live, Routes.offer_type_show_path(conn, :edit, offer_type))

      assert show_live
             |> form("#offer_type-form", offer_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#offer_type-form", offer_type: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.offer_type_show_path(conn, :show, offer_type))

      assert html =~ "Offer type updated successfully"
      assert html =~ "some updated color"
    end
  end
end
