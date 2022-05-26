defmodule Parzival.Repo.Seeds.Companies do
  alias Parzival.Repo

  alias Parzival.Companies.Company

  def run do
    seed_companies()
  end

  def seed_companies() do
    case Repo.all(Company) do
      [] ->
        for _n <- 1..40 do
          Company.changeset(
            %Company{},
            %{
              name: Faker.Company.name(),
              description: Faker.Lorem.sentence(20..40)
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
