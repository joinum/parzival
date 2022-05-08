defmodule Parzival.Repo.Seeds.Accounts do
  alias Parzival.Repo

  alias Parzival.Accounts.User

  def run do
    seed_users()
  end

  def seed_users do
    case Repo.all(User) do
      [] ->
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
          },
          %{
            name: "Beatriz Rocha",
            email: "bea@cesium.pt",
            password: "Password1234",
            role: :staff
          },
          %{
            name: "CeSIUM",
            email: "geral@cesium.pt",
            password: "Password1234",
            role: :company
          },
          %{
            name: "Matilde Bravo",
            email: "matilde@mail.pt",
            password: "Password1234",
            role: :attendee,
            course: "Medicine",
            cycle: :Phd,
            balance: 1000
          },
          %{
            name: "Carlos Ferreira",
            email: "carlos@mail.pt",
            password: "Password1234",
            role: :attendee,
            course: "Software Engineering",
            cycle: :Bachelors,
            cellphone: "+253934674465",
            website: "carl.os",
            linkedin: "CarlosHSF99",
            github: "CarlosHSF99",
            twitter: "CarlosHSF99",
            balance: 1000
          },
          %{
            name: "Maria Pires",
            email: "maria@mail.pt",
            password: "Password1234",
            role: :attendee,
            course: "Sociology",
            cycle: :Masters,
            balance: 1000
          },
          %{
            name: "Nelson Estevao",
            email: "nelson@mail.pt",
            password: "Password1234",
            role: :attendee,
            course: "Marketing",
            cycle: :Phd,
            balance: 1000
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
