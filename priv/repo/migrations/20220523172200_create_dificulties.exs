defmodule Parzival.Repo.Migrations.CreateDifficulties do
  use Ecto.Migration

  def change do
    create table(:difficulties, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string
      add :color, :string

      timestamps()
    end
  end
end
