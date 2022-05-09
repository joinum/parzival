defmodule Parzival.Repo.Migrations.CreateOfferTypes do
  use Ecto.Migration

  def change do
    create table(:offer_types, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string
      add :color, :string

      timestamps()
    end
  end
end
