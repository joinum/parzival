defmodule Parzival.Repo.Seeds.Companies do
  alias Parzival.Repo

  alias Parzival.Companies.Company
  alias Parzival.Companies.Level

  def run do
    seed_levels()
    seed_companies()
  end

  def seed_levels() do
    case Repo.all(Level) do
      [] ->
        Level.changeset(
          %Level{},
          %{
            name: "Exclusive",
            color: "purple"
          }
        )
        |> Repo.insert!()

        Level.changeset(
          %Level{},
          %{
            name: "Gold",
            color: "yellow"
          }
        )
        |> Repo.insert!()

        Level.changeset(
          %Level{},
          %{
            name: "Silver",
            color: "gray"
          }
        )
        |> Repo.insert!()

        Level.changeset(
          %Level{},
          %{
            name: "Bronze",
            color: "amber"
          }
        )
        |> Repo.insert!()

      _ ->
        Mix.shell().error("Found companies, aborting seeding companies.")
    end
  end

  def seed_companies() do
    levels = Repo.all(Level)

    case Repo.all(Company) do
      [] ->
        for _n <- 1..40 do
          Company.changeset(
            %Company{},
            %{
              name: Faker.Company.name(),
              description: Faker.Lorem.sentence(20..40),
              level_id: Enum.random(levels).id
            }
          )
          |> Repo.insert!()
        end

      _ ->
        Mix.shell().error("Found companies, aborting seeding companies.")
    end
  end
end

Parzival.Repo.Seeds.Companies.run()
