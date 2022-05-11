defmodule Parzival.Gamification.Curriculum.Positions do
  @moduledoc """
  A position.
  """
  use Parzival.Schema
  import Ecto.Changeset

  @required_fields ~w(title start current)a

  @optional_fields [:finish]

  embedded_schema do
    field :title, :string
    field :start, :date
    field :finish, :date
    field :current, :boolean

    timestamps()
  end

  @doc false
  def changeset(position, attrs) do
    position
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
