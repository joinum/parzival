defmodule Parzival.Gamification.Curriculum.Language do
  @moduledoc """
  A language.
  """
  use Parzival.Schema
  import Ecto.Changeset

  @proficiencies [:Native, :Fluent, :Intermediary, :Basic]

  @required_fields ~w(idiom proficiency)a

  @optional_fields ~w(delete)a

  embedded_schema do
    field :idiom, :string
    field :proficiency, Ecto.Enum, values: @proficiencies

    field :delete, :boolean, virtual: true

    timestamps()
  end

  @doc false
  def changeset(languages, attrs) do
    languages
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> maybe_mark_for_deletion()
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
