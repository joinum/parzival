defmodule Parzival.Repo.Migrations.CreateMissionsUsers do
  use Ecto.Migration

  def change do
    create table(:missions_users, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :mission_id, references(:missions, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:missions_users, [:mission_id])
    create index(:missions_users, [:user_id])

    create unique_index(:missions_users, [:user_id, :mission_id])
  end
end
