defmodule Parzival.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :expires_at, :naive_datetime

      add :boost_id, references(:boosts, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:items, [:boost_id])
    create index(:items, [:user_id])
  end
end
