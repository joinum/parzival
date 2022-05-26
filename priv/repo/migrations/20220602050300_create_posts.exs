defmodule Parzival.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :text, :text

      add :author_id, references(:users, on_delete: :nilify_all, type: :binary_id)
      add :offer_id, references(:offers, on_delete: :nilify_all, type: :binary_id)

      timestamps()
    end
  end
end
