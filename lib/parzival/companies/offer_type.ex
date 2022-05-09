defmodule Parzival.Companies.OfferType do
  use Parzival.Schema

  alias Parzival.Companies.Offer

  @colors ~w(gray red orange amber yellow lime green emerald teal cyan sky blue indigo violet purple fuchsia pink rose)a

  @derive {
    Flop.Schema,
    filterable: [:name],
    sortable: [:name],
    compound_fields: [search: [:name]],
    default_order_by: [:name],
    default_order_directions: [:asc]
  }

  schema "offer_types" do
    field :name, :string
    field :color, Ecto.Enum, values: @colors

    has_many :offers, Offer

    timestamps()
  end

  @doc false
  def changeset(offer_type, attrs) do
    offer_type
    |> cast(attrs, [:name, :color])
    |> validate_required([:name, :color])
  end
end
