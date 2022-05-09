defmodule Parzival.Missions.Task_Completion do
  @moduledoc """
  An entry created every time a participant
  completes a task.
  """
  use Parzival.Schema

  alias Parzival.Missions
  alias Parzival.Accounts

  @required_fields ~w(participant_id staff_id mission_id)a
  @optional_fields []
  schema "task_completions" do
    belongs_to :participant, Accounts.User
    belongs_to :staff, Accounts.User
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
