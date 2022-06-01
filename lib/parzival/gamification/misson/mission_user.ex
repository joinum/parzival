defmodule Parzival.Gamification.Mission.MissionUser do
  @moduledoc """
  Connection betteween a Mission and an User.
  """
  use Parzival.Schema

  alias Parzival.Accounts.User
  alias Parzival.Gamification.Mission

  @required_fields ~w(user_id mission_id)a

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
