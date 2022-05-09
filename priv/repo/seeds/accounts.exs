defmodule Parzival.Repo.Seeds.Accounts do
  alias Parzival.Repo

  alias Parzival.Accounts.User
  alias Parzival.Companies.Company

  @attendees File.read!("priv/fake/attendees.txt") |> String.split("\n")
  @recruiters File.read!("priv/fake/recruiters.txt") |> String.split("\n")
  @courses File.read!("priv/fake/uminho_courses.txt") |> String.split("\n")

  def run do
    seed_users()
  end

  def seed_users do
    case Repo.all(User) do
      [] ->
        for attendee <- @attendees do
          email =
            String.downcase(attendee)
            |> String.normalize(:nfd)
            |> String.replace(~r/[^A-z\s]/u, "")
            |> String.replace(" ", "_")

          %{
            name: attendee,
            email: email <> "@mail.pt",
            password: "Password1234",
            role: :attendee,
            course: Enum.random(@courses),
            cycle: Enum.random([:Bachelors, :Masters, :Phd]),
            cellphone:
              "+351 9#{Enum.random([1, 2, 3, 6])}#{for _ <- 1..7, do: Enum.random(0..9) |> Integer.to_string()}",
            website: email <> "." <> Faker.Internet.domain_suffix(),
            linkedin: email,
            github: email,
            twitter: email,
            balance: Enum.random(1000..9999)
          }
          |> insert_user()
        end

        companies = Repo.all(Company)

        for recruiter <- @recruiters do
          email =
            String.downcase(recruiter)
            |> String.normalize(:nfd)
            |> String.replace(~r/[^A-z\s]/u, "")
            |> String.replace(" ", "_")

          %{
            name: recruiter,
            email: email <> "@mail.pt",
            password: "Password1234",
            role: :recruiter,
            cellphone:
              "+351 9#{Enum.random([1, 2, 3, 6])}#{for _ <- 1..7, do: Enum.random(0..9) |> Integer.to_string()}",
            website: email <> "." <> Faker.Internet.domain_suffix(),
            linkedin: email,
            github: email,
            twitter: email,
            company_id: Enum.random(companies).id
          }
          |> insert_user()
        end

        [
          %{
            name: "Filipe Felício",
            email: "felicio@cesium.pt",
            password: "Password1234",
            role: :admin
          },
          %{
            name: "Luís Araújo",
            email: "laraujo@cesium.pt",
            password: "Password1234",
            role: :admin
          },
          %{
            name: "David Machado",
            email: "david@necc.pt",
            password: "Password1234",
            role: :admin
          },
          %{
            name: "Maria João Portela",
            email: "mj@nefum.pt",
            password: "Password1234",
            role: :admin
          }
        ]
        |> Enum.each(&insert_user/1)

      _ ->
        Mix.shell().error("Found users, aborting seeding users.")
    end
  end

  defp insert_user(data) do
    %User{}
    |> User.registration_changeset(data)
    |> Repo.insert!()
  end
end

Parzival.Repo.Seeds.Accounts.run()
