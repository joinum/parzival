defmodule Parzival.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :quantity, :integer
      add :redeemed, :integer

      add :product_id, references(:products, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:orders, [:product_id])
    create index(:orders, [:user_id])

    create unique_index(:orders, [:user_id, :product_id])
  end
end
