defmodule Parzival.Repo.Migrations.CreateCurriculums do
  use Ecto.Migration

  def change do
    create table(:curriculums, primary_key: false) do
      add :summary, :text

      add :user_id, references(:users, on_delete: :nilify_all, type: :binary_id)

      timestamps()
    end

    create unique_index(:curriculums, [:user_id])
  end
end
