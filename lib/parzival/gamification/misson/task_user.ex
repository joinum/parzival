defmodule Parzival.Gamification.Mission.TaskUser do
  @moduledoc """
  Connection betteween a Mission and an User.
  """
  use Parzival.Schema

  alias Parzival.Accounts.User
  alias Parzival.Gamification.Mission.Task

  @required_fields ~w(user_id task_id)a

  @optional_fields [:staff_id]

  schema "tasks_users" do
    belongs_to :task, Task
    belongs_to :staff, User
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(offer_time, attrs) do
    offer_time
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:user_id, :task_id])
  end
end
