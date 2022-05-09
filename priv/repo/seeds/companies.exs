defmodule Parzival.Repo.Seeds.Companies do
  alias Parzival.Repo
  alias Parzival.Companies.Company
  alias Parzival.Companies.Offer
  alias Parzival.Companies.OfferType
  alias Parzival.Companies.OfferTime

  def run do
    seed_types()
    seed_times()
    seed_companies()
    seed_offers()
  end

  def seed_types() do
    case Repo.all(OfferType) do
      [] ->
        %OfferType{}
        |> OfferType.changeset(%{
          name: "Intership",
          color: "red"
        })
        |> Repo.insert!()

        %OfferType{}
        |> OfferType.changeset(%{
          name: "Job",
          color: "purple"
        })
        |> Repo.insert!()

        %OfferType{}
        |> OfferType.changeset(%{
          name: "Thesis",
          color: "green"
        })
        |> Repo.insert!()

        %OfferType{}
        |> OfferType.changeset(%{
          name: "Thesis",
          color: "orange"
        })
        |> Repo.insert!()

        %OfferType{}
        |> OfferType.changeset(%{
          name: "Summer Intership",
          color: "pink"
        })
        |> Repo.insert!()

      _ ->
        Mix.shell().error("Found offer types, aborting seeding offer types.")
    end
  end

  def seed_times() do
    case Repo.all(OfferTime) do
      [] ->
        %OfferTime{}
        |> OfferTime.changeset(%{
          name: "Full Time",
          color: "green"
        })
        |> Repo.insert!()

        %OfferTime{}
        |> OfferTime.changeset(%{
          name: "Part Time",
          color: "yellow"
        })
        |> Repo.insert!()

      _ ->
        Mix.shell().error("Found offer times, aborting seeding offer times.")
    end
  end

  def seed_companies() do
    case Repo.all(Offer) do
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

  def seed_offers do
    companies = Repo.all(Company)
    offer_types = Repo.all(OfferType)
    offer_times = Repo.all(OfferTime)

    case Repo.all(Offer) do
      [] ->
        for company <- companies do
          for _n <- 1..10 do
            minimum_salary = Enum.random(1000..3000)

            Offer.changeset(
              %Offer{},
              %{
                minimum_salary: minimum_salary,
                maximum_salary: minimum_salary + Enum.random(500..3000),
                title: Faker.Lorem.sentence(2),
                description: Faker.Lorem.sentence(100..300),
                location: "#{Faker.Address.En.city()}, #{Faker.Address.En.country()}",
                offer_time_id: Enum.random(offer_times).id,
                offer_type_id: Enum.random(offer_types).id,
                company_id: company.id
              }
            )
            |> Repo.insert!()
          end
        end

      _ ->
        Mix.shell().error("Found offers, aborting seeding offers.")
    end
  end
end

Parzival.Repo.Seeds.Companies.run()
