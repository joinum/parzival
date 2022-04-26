defmodule ParzivalWeb.SpeakersController do
  use ParzivalWeb, :controller

   @days [
    %{
      day: "28 de Junho",
      speakers:
        [
          %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
          %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
          %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
          %{name: "Filipe Felício", photo: "luis", job: "Organizer", company: "CeSIUM"}
        ]
    },
    %{
      day: "29 de Junho",
      speakers:
        [
          %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
          %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
          %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
          %{name: "Filipe Felício", photo: "luis", job: "Organizer", company: "CeSIUM"},
          %{name: "Filipe Felício", photo: "luis", job: "Organizer", company: "CeSIUM"}
        ]
    },
    %{
      day: "30 de Junho",
      speakers:
        [
          %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
          %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
          %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
          %{name: "Filipe Felício", photo: "luis", job: "Organizer", company: "CeSIUM"},
          %{name: "Filipe Felício", photo: "luis", job: "Organizer", company: "CeSIUM"}
        ]
    }
  ]

  def index(conn, _params) do
    conn
    |> assign(:current_page, "Speakers")
    |> assign(:days, @days)
    |> render("index.html")
  end
end
