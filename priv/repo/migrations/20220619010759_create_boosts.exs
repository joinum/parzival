defmodule Parzival.Repo.Migrations.CreateBoosts do
  use Ecto.Migration

  def change do
    create table(:boosts, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string
      add :description, :string
      add :price, :integer
      add :type, :string
      add :multiplier, :float

      add :image, :string

      timestamps()
    end
  end
end
