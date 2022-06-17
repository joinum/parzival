defmodule Parzival.Companies.Level do
  @moduledoc """
  A company's sponsorship level.
  """
  use Parzival.Schema

  alias Parzival.Companies.Company

  @colors ~w(gray red orange amber yellow lime green emerald teal cyan sky blue indigo violet purple fuchsia pink rose)a

  @derive {
    Flop.Schema,
    filterable: [:search],
    sortable: [:name],
    compound_fields: [search: [:name]],
    default_order_by: [:name],
    default_order_directions: [:asc]
  }

  schema "levels" do
    field :name, :string
    field :color, Ecto.Enum, values: @colors

    has_many :companies, Company

    timestamps()
  end

  @doc false
  def changeset(level, attrs) do
    level
    |> cast(attrs, [:name, :color])
    |> validate_required([:name, :color])
  end
end
