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
end
