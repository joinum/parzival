defmodule Parzival.Gamification.Curriculum.Experience do
  use Parzival.Schema
  import Ecto.Changeset

  alias Parzival.Gamification.Curriculum

  @required_fields ~w(company_name)a

  @optional_fields []

  embedded_schema do
    field :company_name, :string

    embeds_many :job, Curriculum.Job

    timestamps()
  end

  @doc false
  def changeset(experience, attrs) do
    experience
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_job()
  end

  defp validate_job(changeset) do
    changeset
    |> cast_embed(:job, with: &Curriculum.Job.changeset/2)
  end
end
