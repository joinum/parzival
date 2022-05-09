defmodule Parzival.Gamification.Curriculum.Education do
  use Parzival.Schema
  import Ecto.Changeset

  @required_fields ~w(education_title date description)a

  @optional_fields []

  embedded_schema do
    field :education_title, :string
    field :date, :date
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(education, attrs) do
    education
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
