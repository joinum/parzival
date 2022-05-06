defmodule Parzival.Gamification.Curriculum.Experience do
  use Ecto.Schema
  import Ecto.Changeset

  alias Parzival.Gamification.Curriculum

  @required_fields ~w()a

  @optional_fields [:company_name]

  embedded_schema do
    field :company_name, :string

    embeds_many :job, Curriculum.Job

    timestamps()
  end

  @doc false
  def changeset(curriculum, attrs) do
    curriculum
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_job()
  end

  defp validate_job(changeset) do
    changeset
    |> cast_embed(:job, with: &Curriculum.Job.changeset/2)
  end
end
