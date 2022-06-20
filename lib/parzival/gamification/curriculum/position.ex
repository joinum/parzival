defmodule Parzival.Gamification.Curriculum.Position do
  @moduledoc """
  A position.
  """
  use Parzival.Schema
  import Ecto.Changeset

  @required_fields ~w(title start current)a

  @optional_fields [:finish, :delete]

  embedded_schema do
    field :title, :string
    field :start, :date
    field :finish, :date
    field :current, :boolean, default: false

    field :delete, :boolean, virtual: true

    timestamps()
  end

  @doc false
  def changeset(position, attrs) do
    position
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
