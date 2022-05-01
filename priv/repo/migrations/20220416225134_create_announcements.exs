defmodule Parzival.Repo.Migrations.CreateAnnouncements do
  use Ecto.Migration

  def change do
    create table(:announcements, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :text, :text

      add :author_id, references(:users, on_delete: :nilify_all, type: :binary_id)

      timestamps()
    end
  end
end
