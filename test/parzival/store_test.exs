defmodule Parzival.StoreTest do
  use Parzival.DataCase

  alias Parzival.Store

  describe "products" do
    alias Parzival.Store.Product
    import Parzival.AccountsFixtures
    import Parzival.StoreFixtures

    @invalid_attrs %{description: nil, max_per_user: nil, name: nil, price: nil, stock: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()

      assert Store.list_products([]) == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Store.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{
        description: "some description",
        max_per_user: 42,
        name: "some name",
        price: 42,
        stock: 42
      }

      assert {:ok, %Product{} = product} = Store.create_product(valid_attrs)
      assert product.description == "some description"
      assert product.max_per_user == 42
      assert product.name == "some name"
      assert product.price == 42
      assert product.stock == 42
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()

      update_attrs = %{
        description: "some updated description",
        max_per_user: 43,
        name: "some updated name",
        price: 43,
        stock: 43
      }

      assert {:ok, %Product{} = product} = Store.update_product(product, update_attrs)
      assert product.description == "some updated description"
      assert product.max_per_user == 43
      assert product.name == "some updated name"
      assert product.price == 43
      assert product.stock == 43
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Store.update_product(product, @invalid_attrs)
      assert product == Store.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Store.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Store.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Store.change_product(product)
    end
  end

  describe "orders" do
    alias Parzival.Store.Order
    import Parzival.AccountsFixtures
    import Parzival.StoreFixtures

    @invalid_attrs %{redeemed: nil, user_id: -1}

    test "list_orders/0 returns all orders" do
      order = order_fixture()

      assert Store.list_orders([]) == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Store.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{
        user_id: user_fixture().id,
        product_id: product_fixture().id,
        redeemed: false
      }

      assert {:ok, %Order{} = order} = Store.create_order(valid_attrs)
      assert order.redeemed == false
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      update_attrs = %{redeemed: true}

      assert {:ok, %Order{} = order} = Store.update_order(order, update_attrs)
      assert order.redeemed == true
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Store.update_order(order, @invalid_attrs)
      assert order == Store.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Store.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Store.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Store.change_order(order)
    end
  end
end
