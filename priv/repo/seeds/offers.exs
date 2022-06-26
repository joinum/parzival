defmodule Parzival.Repo.Seeds.Offers do
  import Ecto.Query

  alias Parzival.Repo

  alias Parzival.Accounts.User
  alias Parzival.Companies.Application
  alias Parzival.Companies.Company
  alias Parzival.Companies.Offer
  alias Parzival.Companies.OfferTime
  alias Parzival.Companies.OfferType
  alias Parzival.Tools.Post

  def run do
    seed_types()
    seed_times()
    seed_offers()
    seed_applications()
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
          name: "Curricular Intership",
          color: "orange"
        })
        |> Repo.insert!()

        %OfferType{}
        |> OfferType.changeset(%{
          name: "Grant",
          color: "gray"
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

  def seed_offers do
    companies = Repo.all(Company)
    offer_types = Repo.all(OfferType)
    offer_times = Repo.all(OfferTime)

    case Repo.all(Offer) do
      [] ->
        for company <- companies do
          for _n <- 1..10 do
            minimum_salary = Enum.random(1000..3000)

            recruiters =
              User
              |> where(role: :recruiter)
              |> Repo.all()

            {:ok, offer} =
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
              |> Repo.insert()

            Post.changeset(
              %Post{},
              %{
                text: offer.description,
                author_id: Enum.random(recruiters).id,
                offer_id: offer.id
              }
            )
            |> Repo.insert!()
          end
        end

      _ ->
        Mix.shell().error("Found offers, aborting seeding offers.")
    end
  end

  def seed_applications() do
    users = Repo.all(where(User, role: :attendee))
    offers = Repo.all(Offer)

    case Repo.all(Application) do
      [] ->
        for _n <- 1..200 do
          Application.changeset(
            %Application{},
            %{
              user_id: Enum.random(users).id,
              offer_id: Enum.random(offers).id
            }
          )
          |> Repo.insert!()
        end

      _ ->
        Mix.shell().error("Found applications, aborting seeding applications.")
    end
  end
end

Parzival.Repo.Seeds.Offers.run()
