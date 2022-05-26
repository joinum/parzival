defmodule Parzival.Gamification.Curriculum.Experience do
  @moduledoc """
  A experience.
  """
  use Parzival.Schema
  import Ecto.Changeset

  alias Parzival.Gamification.Curriculum

  @required_fields ~w(organization)a

  @optional_fields ~w(delete)a

  embedded_schema do
    field :organization, :string

    field :delete, :boolean, virtual: true

    embeds_many :positions, Curriculum.Position

    timestamps()
  end

  @doc false
  def changeset(experience, attrs) do
    experience
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_positions()
    |> maybe_mark_for_deletion()
  end

  defp validate_positions(changeset) do
    changeset
    |> cast_embed(:positions, with: &Curriculum.Position.changeset/2, required: true)
  end

  defp maybe_mark_for_deletion(%{data: %{id: nil}} = changeset), do: changeset

  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
