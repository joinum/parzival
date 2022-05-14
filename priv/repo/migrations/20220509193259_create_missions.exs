defmodule Parzival.Repo.Migrations.CreateMissions do
  use Ecto.Migration

  def change do
    create table(:missions, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :title, :text
      add :description, :text

      timestamps()
    end

    create unique_index(:missions, [:title, :description])

    create table(:tasks, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :title, :text
      add :description, :text
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime

      add :mission_id, references(:missions, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:tasks, [:title, :description, :mission_id])

    create table(:task_completions, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :task_id, references(:tasks, on_delete: :nothing, type: :binary_id)
      add :participant_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :staff_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:task_completions, [:task_id, :participant_id])
  end
end
