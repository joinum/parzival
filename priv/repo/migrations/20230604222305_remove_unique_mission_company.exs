defmodule Parzival.Repo.Migrations.RemoveUniqueMissionCompany do
  use Ecto.Migration

  def change do
    drop unique_index(:missions, [:created_by_id])
  end
end
