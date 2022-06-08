defmodule Parzival.Gamification.Mission.Task do
  @moduledoc """
  A task.
  """
  use Parzival.Schema
  import Ecto.Changeset

  alias Parzival.Accounts.User
  alias Parzival.Gamification.Mission
  alias Parzival.Gamification.Mission.TaskUser

  @required_fields ~w(title description mission_id)a

  @optional_fields [
    :tokens,
    :exp
  ]

  schema "tasks" do
    field :title, :string
    field :description, :string
    field :tokens, :integer
    field :exp, :integer

    belongs_to :mission, Mission

    many_to_many :users, User, join_through: TaskUser

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def mission_changeset(task, attrs) do
    task
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields -- [:mission_id])
  end
end
