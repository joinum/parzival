defmodule Parzival.Repo.Migrations.CreateTasksUsers do
  use Ecto.Migration

  def change do
    create table(:tasks_users, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :task_id, references(:tasks, on_delete: :nothing, type: :binary_id)
      add :staff_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:tasks_users, [:task_id])
    create index(:tasks_users, [:staff_id])
    create index(:tasks_users, [:user_id])

    create unique_index(:tasks_users, [:user_id, :task_id])
  end
end
