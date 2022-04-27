defmodule Parzival.Repo.Migrations.CreateFaqs do
  use Ecto.Migration

  def change do
    create table(:faqs, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :question, :text
      add :answer, :text

      timestamps()
    end
  end
end
