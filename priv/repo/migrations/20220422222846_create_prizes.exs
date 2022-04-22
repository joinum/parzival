defmodule Parzival.Repo.Migrations.CreatePrizes do
  use Ecto.Migration

  def change do
    create table(:prizes) do
      add :quantity, :integer
      add :redeemed, :integer

      timestamps()
    end
  end
end
