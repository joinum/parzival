defmodule Parzival.Missions.Task do
  @moduledoc """
  A task needed to complete a mission.
  """
  use Parzival.Schema

  alias Parzival.Missions

  @required_fields ~w(title start_time end_time mission_id)a
  @optional_fields []
  schema "tasks" do
    field :title, :string
    field :description, :string
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    belongs_to :mission, Missions.Mission

    timestamps()
  end

  @doc false
  def changeset(announcement, attrs) do
    announcement
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
