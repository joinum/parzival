defmodule Parzival.Companies.Application do
  @moduledoc """
  A attendee's application to a job offer
  """
  use Parzival.Schema

  alias Parzival.Accounts.User
  alias Parzival.Companies.Offer

  @required_fields ~w(user_id offer_id)a

  @optional_fields []

  @derive {
    Flop.Schema,
    filterable: [:search],
    sortable: [],
    compound_fields: [search: []],
    default_order_by: [],
    default_order_directions: [:asc]
  }

  schema "applications" do
    belongs_to :offer, Offer
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(application, attrs) do
    application
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
