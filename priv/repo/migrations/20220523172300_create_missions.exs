defmodule Parzival.Repo.Migrations.CreateMissions do
  use Ecto.Migration

  def change do
    create table(:missions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :text
      add :tokens, :integer
      add :exp, :integer
      add :level, :integer
      add :start, :naive_datetime
      add :finish, :naive_datetime

      add :created_by_id, references(:companies, on_delete: :nothing, type: :binary_id)

      add :difficulty_id, references(:difficulties, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:missions, [:created_by_id])
  end
end
