defmodule Parzival.Gamification.Curriculum.Skill do
  use Parzival.Schema
  import Ecto.Changeset

  @required_fields ~w(name)a

  @optional_fields []

  embedded_schema do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
