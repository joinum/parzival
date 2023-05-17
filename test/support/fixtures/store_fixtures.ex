defmodule Parzival.StoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Parzival.Store` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        max_per_user: 42,
        name: "some name",
        price: 42,
        stock: 42
      })
      |> Parzival.Store.create_product()

    product
  end

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        product_id: Parzival.StoreFixtures.product_fixture().id,
        user_id: Parzival.AccountsFixtures.user_fixture().id,
        redeemed: false
      })
      |> Parzival.Store.create_order()

    order
  end

  @doc """
  Generate a boost.
  """
  def boost_fixture(attrs \\ %{}) do
    {:ok, boost} =
      attrs
      |> Enum.into(%{
        finish: ~N[2022-06-18 01:07:00]
      })
      |> Parzival.Store.create_boost()

    boost
  end

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{})
      |> Parzival.Store.create_item()

    item
  end
end
