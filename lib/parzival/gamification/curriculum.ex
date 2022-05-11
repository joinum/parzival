defmodule Parzival.Gamification.Curriculum do
  @moduledoc """
  A curriculum.
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
    embeds_many :education, Curriculum.Education
    embeds_many :volunteering, Curriculum.Volunteering
    embeds_many :skills, Curriculum.Skills
    embeds_many :languages, Curriculum.Languages

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
    |> validate_volunteering()
    |> validate_skills()
    |> validate_languages()
  end

  defp validate_experience(changeset) do
    changeset
    |> cast_embed(:experience, with: &Curriculum.Experience.changeset/2)
  end

  defp validate_education(changeset) do
    changeset
    |> cast_embed(:education, with: &Curriculum.Education.changeset/2)
  end

  defp validate_volunteering(changeset) do
    changeset
    |> cast_embed(:volunteering, with: &Curriculum.Volunteering.changeset/2)
  end

  defp validate_skills(changeset) do
    changeset
    |> cast_embed(:skills, with: &Curriculum.Skills.changeset/2)
  end

  defp validate_languages(changeset) do
    changeset
    |> cast_embed(:languages, with: &Curriculum.Languages.changeset/2)
  end
end
