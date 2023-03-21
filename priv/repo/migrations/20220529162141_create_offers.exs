defmodule Parzival.Repo.Migrations.CreateOffers do
  use Ecto.Migration

  def change do
    create table(:offers, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :title, :string

      add :minimum_salary, :integer
      add :maximum_salary, :integer
      add :location, :text
      add :work_model, :text
      add :description, :text

      add :company_id, references(:companies, on_delete: :nothing, type: :binary_id)
      add :offer_type_id, references(:offer_types, on_delete: :nothing, type: :binary_id)
      add :offer_time_id, references(:offer_times, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
  end
end
