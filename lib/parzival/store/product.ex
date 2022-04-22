defmodule Parzival.Store.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :max_per_user, :integer
    field :name, :string
    field :price, :integer
    field :stock, :integer

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :price, :stock, :max_per_user])
    |> validate_required([:name, :description, :price, :stock, :max_per_user])
  end
end
