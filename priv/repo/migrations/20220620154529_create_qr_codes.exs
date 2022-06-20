defmodule Parzival.Repo.Migrations.CreateQRCode do
  use Ecto.Migration

  def change do
    create table(:qr_codes, primary_key: false) do
      add :uuid, :binary_id, primary_key: true

      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:qr_codes, [:user_id])
  end
end
