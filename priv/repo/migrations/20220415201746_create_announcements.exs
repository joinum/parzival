defmodule Parzival.Repo.Migrations.CreateAnnouncements do
  use Ecto.Migration

  def change do
    create table(:announcements, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :title, :string, null: false
      add :content, :text, null: false


      timestamps()
    end
  end
end
