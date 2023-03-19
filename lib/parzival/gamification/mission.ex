defmodule Parzival.Gamification.Mission do
  @moduledoc """
  A mission.
  """
  use Parzival.Schema

  alias Parzival.Accounts.User
  alias Parzival.Companies.Company
  alias Parzival.Gamification.Mission.Difficulty
  alias Parzival.Gamification.Mission.MissionUser
  alias Parzival.Gamification.Mission.Task

  @required_fields ~w(title description exp level tokens difficulty_id)a

  @optional_fields [
    :start,
    :finish,
    :created_by_id
  ]

  @derive {
    Flop.Schema,
    filterable: [:search],
    sortable: [:title],
    compound_fields: [search: [:title]],
    default_order_by: [:title],
    default_order_directions: [:desc]
  }

  schema "missions" do
    field :title, :string
    field :description, :string
    field :tokens, :integer
    field :exp, :integer
    field :level, :integer
    field :start, :naive_datetime
    field :finish, :naive_datetime

    belongs_to :created_by, Company

    belongs_to :difficulty, Difficulty

    has_many :tasks, Task, on_replace: :delete_if_exists

    many_to_many :users, User, join_through: MissionUser, preload_order: [desc: :inserted_at]

    timestamps()
  end

  def changeset(mission, attrs) do
    mission
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_assoc(:tasks,
      required: false,
      with: &Task.task_changeset/2
    )
    |> validate_required(@required_fields)
  end
end
