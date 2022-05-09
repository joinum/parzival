defmodule Parzival.Gamification.Curriculum.Experience do
  @moduledoc """
  A experience.
  """
  use Parzival.Schema
  import Ecto.Changeset

  alias Parzival.Gamification.Curriculum

  @required_fields ~w(organization)a

  @optional_fields []

  embedded_schema do
    field :organization, :string

    embeds_many :positions, Curriculum.Positions

    timestamps()
  end

  @doc false
  def changeset(experience, attrs) do
    experience
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_positions()
  end

  defp validate_positions(changeset) do
    changeset
    |> cast_embed(:positions, with: &Curriculum.Positions.changeset/2, required: true)
  end
end
