defmodule Parzival.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime

      add :name, :string, null: false
      add :role, :string, null: false
      add :course, :string
      add :cycle, :string
      add :cellphone, :string
      add :website, :string
      add :linkedin, :string
      add :github, :string
      add :twitter, :string

      add :exp, :integer

      add :balance, :integer

      add :company_id, references(:companies, on_delete: :nothing, type: :binary_id)

      add :picture, :string

      timestamps()
    end

    create unique_index(:users, [:email])

    create constraint(:users, :balance_must_be_positive, check: "balance >= 0")

    create table(:users_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
  end
end
