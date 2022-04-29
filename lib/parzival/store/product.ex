defmodule Parzival.Store.Product do
  use Parzival.Schema

  alias Parzival.Store.Order
  alias Parzival.Uploaders

  @required_fields ~w(name description
                      price stock
                      max_per_user)a

  @optional_fields []

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :integer
    field :stock, :integer
    field :max_per_user, :integer

    field :image, Uploaders.ProductImage.Type

    has_many :orders, Order

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_attachments(attrs, [:image])
    |> validate_required(@required_fields)
  end

  def stock_changeset(product, attrs) do
    product
    |> cast(attrs, [:stock])
    |> validate_required([:stock])
    |> validate_number(:stock, greater_than_or_equal_to: 0)
  end
end
