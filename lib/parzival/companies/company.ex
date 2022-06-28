defmodule Parzival.Companies.Company do
  @moduledoc """
  A company.
  """
  use Parzival.Schema

  alias Parzival.Accounts.User
  alias Parzival.Companies.Connection
  alias Parzival.Companies.Level
  alias Parzival.Companies.Offer
  alias Parzival.Uploaders

  @required_fields ~w(name description level_id)a

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

    belongs_to :level, Level

    field :picture, Uploaders.ProfilePicture.Type

    has_many :connections, Connection

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_attachments(attrs, [:picture])
    |> validate_required(@required_fields)
  end

  def picture_changeset(company, attrs) do
    company
    |> cast_attachments(attrs, [:picture])
  end
end
