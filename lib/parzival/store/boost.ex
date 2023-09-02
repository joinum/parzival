defmodule Parzival.Store.Boost do
  @moduledoc """
  A boost that can be purchased by a user.
  """
  use Parzival.Schema

  alias Parzival.Store.Item
  alias Parzival.Uploaders

  @types ~w(exp tokens skip_task)a

  @required_fields ~w(name description price type)a
  @optional_fields ~w(multiplier)a

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [:name],
    compound_fields: [search: [:name]],
    default_order_by: [:name],
    default_order_directions: [:asc]
  }

  schema "boosts" do
    field :name, :string
    field :description, :string
    field :price, :integer
    field :type, Ecto.Enum, values: @types
    field :multiplier, :float

    field :image, Uploaders.BoostImage.Type

    has_many :item, Item

    timestamps()
  end

  @doc false
  def changeset(boost, attrs) do
    boost
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_attachments(attrs, [:image])
    |> validate_required(@required_fields)
  end

  def image_changeset(product, attrs) do
    product
    |> cast_attachments(attrs, [:image])
  end
end
