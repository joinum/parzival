defmodule Parzival.Gamification.Mission.Dificulty do
  @moduledoc """
  A type of job offer.
  """
  use Parzival.Schema

  alias Parzival.Gamification.Mission

  @colors ~w(gray red orange amber yellow lime green emerald teal cyan sky blue indigo violet purple fuchsia pink rose)a

  @derive {
    Flop.Schema,
    filterable: [:search],
    sortable: [:name],
    compound_fields: [search: [:name]],
    default_order_by: [:name],
    default_order_directions: [:asc]
  }

  schema "dificulties" do
    field :name, :string
    field :color, Ecto.Enum, values: @colors

    has_many :missions, Mission

    timestamps()
  end

  @doc false
  def changeset(offer_type, attrs) do
    offer_type
    |> cast(attrs, [:name, :color])
    |> validate_required([:name, :color])
  end
end
