defmodule Parzival.Repo.Migrations.CreateDificulties do
  use Ecto.Migration

  def change do
    create table(:dificulties, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string
      add :color, :string

      timestamps()
    end
  end
end
