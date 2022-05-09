defmodule Parzival.Gamification.Curriculum do
  @moduledoc """
  A user of the application capable of authenticating.
  """
  use Parzival.Schema

  alias Parzival.Accounts
  alias Parzival.Gamification.Curriculum

  @required_fields ~w(user_id summary)a

  @optional_fields []

  schema "curriculums" do
    field :summary, :string

    embeds_many :experiences, Curriculum.Experience
    embeds_many :educations, Curriculum.Education
    embeds_many :voluntaries, Curriculum.Voluntary
    embeds_many :skills, Curriculum.Skill
    embeds_many :languages, Curriculum.Language

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
    |> validate_education()
    |> validate_voluntary()
    |> validate_skill()
    |> validate_language()
  end

  defp validate_experience(changeset) do
    changeset
    |> cast_embed(:experiences, with: &Curriculum.Experience.changeset/2)
  end

  defp validate_education(changeset) do
    changeset
    |> cast_embed(:educations, with: &Curriculum.Education.changeset/2)
  end

  defp validate_voluntary(changeset) do
    changeset
    |> cast_embed(:voluntaries, with: &Curriculum.Voluntary.changeset/2)
  end

  defp validate_skill(changeset) do
    changeset
    |> cast_embed(:skills, with: &Curriculum.Skill.changeset/2)
  end

  defp validate_language(changeset) do
    changeset
    |> cast_embed(:languages, with: &Curriculum.Language.changeset/2)
  end
end
