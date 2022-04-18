defmodule Parzival.Repo.Migrations.CreateAnnouncements do
  use Ecto.Migration

  def change do
    create table(:announcements) do
      add :title, :string
      add :text, :text

      # add :author_id, references(:users, on_delete: :nilify_all, type: :binary_id)

      timestamps()
    end
  end
end
