defmodule ParzivalWeb.TeamController do
  use ParzivalWeb, :controller

  @team [
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

  @organizers ["cesium","necc","nefum","di"]

  def index(conn, _params) do

    conn
    |> assign(:current_page, "team")
    |> assign(:team, @team)
    |> assign(:organizers, @organizers)
    |> render("index.html")
  end
end
