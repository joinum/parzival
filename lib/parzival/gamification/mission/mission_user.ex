defmodule Parzival.Gamification.Mission.MissionUser do
  @moduledoc """
  Connection betteween a Mission and an User.
  """
  use Parzival.Schema

  alias Parzival.Accounts.User
  alias Parzival.Gamification.Mission

  @required_fields ~w(user_id mission_id)a

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [:inserted_at],
    compound_fields: [],
    default_order_by: [:inserted_at],
    default_order_directions: [:desc]
  }

  schema "missions_users" do
    belongs_to :mission, Mission
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(offer_time, attrs) do
    offer_time
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
