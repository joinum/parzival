defmodule Parzival.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :text
      add :tokens, :integer
      add :exp, :integer

      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :mission_id, references(:missions, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end
  end
end
