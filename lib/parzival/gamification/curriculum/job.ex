defmodule Parzival.Gamification.Curriculum.Job do
  use Parzival.Schema
  import Ecto.Changeset

  @required_fields ~w(job_title start_date end_date)a

  @optional_fields [
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
  def changeset(job, attrs) do
    job
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
