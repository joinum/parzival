defmodule Parzival.Gamification.Curriculum.Voluntary do
  use Parzival.Schema
  import Ecto.Changeset

  @required_fields ~w(voluntary_title date)a

  @optional_fields []

  embedded_schema do
    field :voluntary_title, :string
    field :date, :date

    timestamps()
  end

  @doc false
  def changeset(voluntary, attrs) do
    voluntary
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
