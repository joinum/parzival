defmodule Parzival.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text

      add :level_id, references(:levels, on_delete: :nothing, type: :binary_id)

      add :picture, :string

      timestamps()
    end
  end
end
