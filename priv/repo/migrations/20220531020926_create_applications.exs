defmodule Parzival.Repo.Migrations.CreateApplications do
  use Ecto.Migration

  def change do
    create table(:applications, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :offer_id, references(:offers, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
  end
end
