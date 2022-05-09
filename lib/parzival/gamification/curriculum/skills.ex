defmodule Parzival.Gamification.Curriculum.Skills do
  @moduledoc """
  A skill.
  """
  use Parzival.Schema
  import Ecto.Changeset

  @required_fields ~w(name)a

  @optional_fields []

  embedded_schema do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(skills, attrs) do
    skills
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
