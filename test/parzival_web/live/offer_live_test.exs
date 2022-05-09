defmodule ParzivalWeb.OfferLiveTest do
  use ParzivalWeb.ConnCase

  import Phoenix.LiveViewTest
  import Parzival.CompaniesFixtures

  @create_attrs %{maximum_salary: 42, minimum_salary: 42, title: "some title", type: "some type"}
  @update_attrs %{
    maximum_salary: 43,
    minimum_salary: 43,
    title: "some updated title",
    type: "some updated type"
  }
  @invalid_attrs %{maximum_salary: nil, minimum_salary: nil, title: nil, type: nil}

  defp create_offer(_) do
    offer = offer_fixture()
    %{offer: offer}
  end

  describe "Index" do
    setup [:create_offer]

    test "lists all offers", %{conn: conn, offer: offer} do
      {:ok, _index_live, html} = live(conn, Routes.offer_index_path(conn, :index))

      assert html =~ "Listing Offers"
      assert html =~ offer.title
    end

    test "saves new offer", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.offer_index_path(conn, :index))

      assert index_live |> element("a", "New Offer") |> render_click() =~
               "New Offer"

      assert_patch(index_live, Routes.offer_index_path(conn, :new))

      assert index_live
             |> form("#offer-form", offer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#offer-form", offer: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.offer_index_path(conn, :index))

      assert html =~ "Offer created successfully"
      assert html =~ "some title"
    end

    test "updates offer in listing", %{conn: conn, offer: offer} do
      {:ok, index_live, _html} = live(conn, Routes.offer_index_path(conn, :index))

      assert index_live |> element("#offer-#{offer.id} a", "Edit") |> render_click() =~
               "Edit Offer"

      assert_patch(index_live, Routes.offer_index_path(conn, :edit, offer))

      assert index_live
             |> form("#offer-form", offer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#offer-form", offer: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.offer_index_path(conn, :index))

      assert html =~ "Offer updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes offer in listing", %{conn: conn, offer: offer} do
      {:ok, index_live, _html} = live(conn, Routes.offer_index_path(conn, :index))

      assert index_live |> element("#offer-#{offer.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#offer-#{offer.id}")
    end
  end

  describe "Show" do
    setup [:create_offer]

    test "displays offer", %{conn: conn, offer: offer} do
      {:ok, _show_live, html} = live(conn, Routes.offer_show_path(conn, :show, offer))

      assert html =~ "Show Offer"
      assert html =~ offer.title
    end

    test "updates offer within modal", %{conn: conn, offer: offer} do
      {:ok, show_live, _html} = live(conn, Routes.offer_show_path(conn, :show, offer))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Offer"

      assert_patch(show_live, Routes.offer_show_path(conn, :edit, offer))

      assert show_live
             |> form("#offer-form", offer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#offer-form", offer: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.offer_show_path(conn, :show, offer))

      assert html =~ "Offer updated successfully"
      assert html =~ "some updated title"
    end
  end
end
