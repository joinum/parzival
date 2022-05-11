defmodule Parzival.Gamification.Curriculum.Education do
  @moduledoc """
  An education.
  """
  use Parzival.Schema
  import Ecto.Changeset

  @required_fields ~w(institution course start finish)a

  @optional_fields []

  embedded_schema do
    field :institution, :string
    field :course, :string
    field :start, :date
    field :finish, :date

    timestamps()
  end

  @doc false
  def changeset(education, attrs) do
    education
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
