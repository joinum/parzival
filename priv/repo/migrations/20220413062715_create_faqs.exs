defmodule Parzival.Repo.Migrations.CreateFaqs do
  use Ecto.Migration

  def change do
    create table(:faqs) do
      add :question, :text
      add :answer, :text

      timestamps()
    end
  end
end
