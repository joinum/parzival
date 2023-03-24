defmodule Parzival.Companies.Offer do
  @moduledoc """
  A job offer.
  """
  use Parzival.Schema

  alias Parzival.Companies.Application
  alias Parzival.Companies.Company
  alias Parzival.Companies.OfferTime
  alias Parzival.Companies.OfferType

  @required_fields ~w(maximum_salary minimum_salary title location work_model description company_id offer_type_id offer_time_id)a

  @optional_fields []

  @work_models ~w(remote hybrid on_site)a

  @derive {
    Flop.Schema,
    filterable: [:search],
    sortable: [:title, :minimum_salary, :maximum_salary],
    compound_fields: [search: [:title]],
    default_order_by: [:minimum_salary, :maximum_salary],
    default_order_directions: [:desc, :desc]
  }

  schema "offers" do
    field :maximum_salary, :integer
    field :minimum_salary, :integer
    field :title, :string
    field :location, :string
    field :work_model, Ecto.Enum, values: @work_models
    field :description, :string

    field :applied, :integer, virtual: true

    belongs_to :company, Company
    belongs_to :offer_type, OfferType
    belongs_to :offer_time, OfferTime

    has_many :applications, Application

    has_many :users, through: [:applications, :user]

    timestamps()
  end

  @doc false
  def changeset(offer, attrs) do
    offer
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
