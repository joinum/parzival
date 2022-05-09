defmodule Parzival.Repo.Seeds.Accounts do
  alias Parzival.Repo

  alias Parzival.Accounts.User

  @attendees File.read!("priv/fake/attendees.txt") |> String.split("\n")
  @courses File.read!("priv/fake/uminho_courses.txt") |> String.split("\n")

  def run do
    seed_users()
  end

  def seed_users do
    case Repo.all(User) do
      [] ->
        for attendee <- @attendees do
          first_last_name = String.downcase(attendee) |> String.replace(" ", "_")

          %{
            name: attendee,
            email: first_last_name <> "@mail.pt",
            password: "Password1234",
            role: :attendee,
            course: Enum.random(@courses),
            cycle: Enum.random([:Bachelors, :Masters, :Phd]),
            cellphone:
              "+351 9#{Enum.random([1, 2, 3, 6])}#{for _ <- 1..7, do: Enum.random(0..9) |> Integer.to_string()}",
            website: first_last_name <> "." <> Faker.Internet.domain_suffix(),
            linkedin: first_last_name,
            github: first_last_name,
            twitter: first_last_name,
            balance: Enum.random(100..999)
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
