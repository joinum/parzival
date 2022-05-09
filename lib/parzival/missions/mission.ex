defmodule Parzival.Missions.Mission do
  @moduledoc """
  A  mission.
  """
  use Parzival.Schema

  alias Parzival.Missions

  @required_fields ~w(title)a
  @optional_fields []
  schema "missions" do
    field :title, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(announcement, attrs) do
    announcement
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
