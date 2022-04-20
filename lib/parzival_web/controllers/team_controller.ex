defmodule ParzivalWeb.TeamController do
  use ParzivalWeb, :controller

  def index(conn, _params) do
    team = [
      %{
        name: "Filipe Felício",
        photo: "filipe",
        organization: :cesium,
        linkedin: "",
        github: "",
        twitter: ""
      },
      %{
        name: "Filipe Felício",
        photo: "filipe",
        organization: :necc,
        linkedin: "",
        github: "",
        twitter: ""
      },
      %{
        name: "Filipe Felício",
        photo: "filipe",
        organization: :nefum,
        linkedin: "",
        github: "",
        twitter: ""
      },
      %{
        name: "Filipe Felício",
        photo: "filipe",
        organization: :cesium,
        linkedin: "",
        github: "",
        twitter: ""
      },
      %{
        name: "Filipe Felício",
        photo: "filipe",
        organization: :cesium,
        linkedin: "",
        github: "",
        twitter: ""
      }
    ]

    conn
    |> assign(:current_page, "team")
    |> assign(:team, team)
    |> render("index.html")
  end
end
