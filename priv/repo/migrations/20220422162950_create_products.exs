defmodule Parzival.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :string
      add :price, :integer
      add :stock, :integer
      add :max_per_user, :integer

      timestamps()
    end
  end
end
