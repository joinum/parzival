defmodule Parzival.Gamification.Curriculum.Language do
  use Parzival.Schema
  import Ecto.Changeset

  @proficiencies [:Native, :Fluent, :Intermediary, :Basic]

  @required_fields ~w(idiom proficiency)a

  @optional_fields []

  embedded_schema do
    field :idiom, :string
    field :proficiency, Ecto.Enum, values: @proficiencies

    timestamps()
  end

  @doc false
  def changeset(language, attrs) do
    language
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
