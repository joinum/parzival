defmodule Parzival.Store.Order do
  @moduledoc """
  A order of a product from a user.
  """
  use Parzival.Schema

  alias Parzival.Accounts.User
  alias Parzival.Store.Product

  @required_fields ~w(user_id product_id)a

  @optional_fields [
    :redeemed
  ]

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [],
    compound_fields: [search: []],
    default_order_by: [],
    default_order_directions: [:asc]
  }

  schema "orders" do
    field :redeemed, :boolean, default: false

    belongs_to :user, User
    belongs_to :product, Product

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
