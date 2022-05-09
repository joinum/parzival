defmodule Parzival.Companies.Company do
  use Parzival.Schema

  alias Parzival.Companies.Offer
  alias Parzival.Accounts.User

  @required_fields ~w(name description)a

  @optional_fields []

  @derive {
    Flop.Schema,
    filterable: [:search],
    sortable: [:name],
    compound_fields: [search: [:name]],
    default_order_by: [:name],
    default_order_directions: [:asc]
  }

  schema "companies" do
    field :description, :string
    field :name, :string

    has_many :offers, Offer
    has_many :recruiters, User

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
