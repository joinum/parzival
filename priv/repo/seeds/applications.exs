defmodule Parzival.Repo.Seeds.Applications do
  alias Parzival.Repo

  alias Parzival.Accounts.User

  alias Parzival.Companies.Application
  alias Parzival.Companies.Offer

  def run do
    seed_applications()
  end

  def seed_applications() do
    users = Repo.all(User)
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

Parzival.Repo.Seeds.Applications.run()
