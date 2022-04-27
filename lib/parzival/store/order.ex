defmodule Parzival.Store.Order do
  use Parzival.Schema

  alias Parzival.Accounts.User
  alias Parzival.Store.Product

  @required_fields ~w(quantity user_id product_id)a

  @optional_fields [
    :redeemed
  ]

  schema "orders" do
    field :quantity, :integer
    field :redeemed, :integer, default: 0

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
