defmodule Parzival.Gamification.Curriculum.Volunteering do
  @moduledoc """
  A voluntery work.
  """
  use Parzival.Schema
  import Ecto.Changeset

  @required_fields ~w(institution position start finish)a

  @optional_fields []

  embedded_schema do
    field :institution, :string
    field :position, :string
    field :start, :date
    field :finish, :date

    timestamps()
  end

  @doc false
  def changeset(voluntary, attrs) do
    voluntary
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
