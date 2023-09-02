defmodule Parzival.Store.Item do
  @moduledoc """
  An item with a boost that belongs to a user.
  """
  use Parzival.Schema

  alias Parzival.Accounts.User
  alias Parzival.Store.Boost

  @required_fields ~w(user_id boost_id)a

  @optional_fields ~w(expires_at)a

  schema "items" do
    field :expires_at, :naive_datetime

    belongs_to :user, User
    belongs_to :boost, Boost

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
