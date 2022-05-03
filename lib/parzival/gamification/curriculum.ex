defmodule Parzival.Gamification.Curriculum do
  use Ecto.Schema
  import Ecto.Changeset

  alias Parzival.Accounts

  @required_fields ~w(user_id)a

  @optional_fields [
    :summary
  ]

  schema "curriculums" do
    field :summary, :string

    belongs_to :user, Accounts.User

    timestamps()
  end

  @doc false
  def changeset(curriculum, attrs) do
    curriculum
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:user_id)
  end
end
