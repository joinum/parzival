defmodule Parzival.Repo.Migrations.CreateCurriculums do
  use Ecto.Migration

  def change do
    create table(:curriculums, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :summary, :text

      add :experience, {:array, :map}, default: []
      add :education, {:array, :map}, default: []
      add :volunteering, {:array, :map}, default: []
      add :skills, {:array, :map}, default: []
      add :languages, {:array, :map}, default: []

      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create unique_index(:curriculums, [:user_id])
  end
end
