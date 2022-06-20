defmodule Parzival.Repo.Migrations.CreateQRCodes do
  use Ecto.Migration

  def change do
    create table(:qrcodes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :uuid, :binary

      timestamps()
    end
  end
end
