defmodule Parzival.Gamification.Curriculum.Job do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(job_title)a

  @optional_fields [
    :start_date,
    :end_date,
    :present
  ]

  embedded_schema do
    field :job_title, :string
    field :start_date, :date
    field :end_date, :date
    field :present, :boolean

    timestamps()
  end

  @doc false
  def changeset(curriculum, attrs) do
    curriculum
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
