defmodule Parzival.Repo.Seeds.Accounts do

  alias Parzival.Repo

  alias Parzival.Accounts.User

  def run do
    seed_admins()
  end

  def seed_admins do
    case Repo.all(User) do
      [] ->
        [
          %{
            name: "Filipe Felício",
            email: "felicio@cesium.pt",
            password: "Password1234"
          },
          %{
            name: "Luís Araújo",
            email: "laraujo@cesium.pt",
            password: "Password1234"
          },
          %{
            name: "David Machado",
            email: "david@necc.pt",
            password: "Password1234"
          },
          %{
            name: "Maria João Portela",
            email: "mj@nefum.pt",
            password: "Password1234"
          },
        ]
        |> Enum.each(&insert_admin/1)

      _ ->
        Mix.shell().error("Found users, aborting seeding admin users.")
    end
  end

  defp insert_admin(data) do
    %User{}
    |> User.registration_changeset(data)
    |> Repo.insert!()
  end

end

Parzival.Repo.Seeds.Accounts.run()
