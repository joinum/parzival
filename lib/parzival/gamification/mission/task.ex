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
    :exp,
    :delete
  ]

  schema "tasks" do
    field :title, :string
    field :description, :string
    field :tokens, :integer
    field :exp, :integer

    field :delete, :boolean, virtual: true

    belongs_to :mission, Mission

    many_to_many :users, User, join_through: TaskUser, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> maybe_mark_for_deletion()
  end

  def task_changeset(task, attrs) do
    task
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields -- [:mission_id])
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
