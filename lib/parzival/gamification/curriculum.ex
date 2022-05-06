defmodule Parzival.Gamification.Curriculum do
  @moduledoc """
  A user of the application capable of authenticating.
  """
  use Parzival.Schema

  alias Parzival.Accounts
  alias Parzival.Gamification.Curriculum

  @required_fields ~w(user_id)a

  @optional_fields [
    :summary
  ]

  schema "curriculums" do
    field :summary, :string

    embeds_many :experience, Curriculum.Experience

    belongs_to :user, Accounts.User

    timestamps()
  end

  def changeset(curriculum, attrs) do
    curriculum
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unsafe_validate_unique(:user_id, Parzival.Repo)
    |> unique_constraint(:user_id)
    |> validate_experience()
  end

  defp validate_experience(changeset) do
    changeset
    |> cast_embed(:experience, with: &Curriculum.Experience.changeset/2)
  end
end
