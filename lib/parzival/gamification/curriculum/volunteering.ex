defmodule Parzival.Gamification.Curriculum.Volunteering do
  @moduledoc """
  A voluntery work.
  """
  use Parzival.Schema
  import Ecto.Changeset

  @required_fields ~w(institution position start finish)a

  @optional_fields ~w(delete)a

  embedded_schema do
    field :institution, :string
    field :position, :string
    field :start, :date
    field :finish, :date

    field :delete, :boolean, virtual: true

    timestamps()
  end

  @doc false
  def changeset(voluntary, attrs) do
    voluntary
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
