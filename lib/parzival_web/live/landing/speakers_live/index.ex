defmodule ParzivalWeb.Landing.SpeakersLive.Index do
  @moduledoc false
  use ParzivalWeb, [:live_view, {ParzivalWeb.LayoutView, "landing.html"}]

  require Integer

  @days [
    %{
      day: "28 de Junho",
      speakers: [
        %{
          name: "Roberto Machado",
          photo: "roberto",
          job: "Co-Founder & CEO",
          company: "Subvisual"
        },
        %{name: "Mário Gago", photo: "mario_gago", job: "CEO", company: "Pink Room"},
        %{
          name: "Diogo Viana",
          photo: "diogo_viana",
          job: "",
          company: "Full Stack Software Engineer"
        },
        %{name: "André Maximino", photo: "join", job: "", company: "Pink Room"},
        %{
          name: "Miguel Palhas",
          photo: "miguel_palhas",
          job: "Blockchain Developer",
          company: "Subvisual"
        },
        %{
          name: "Diogo Teixeira",
          photo: "diogo_teixeira",
          job: "Advanced Application Specialist",
          company: "Accenture"
        }
      ]
    }
    # %{
    #   day: "29 de Junho",
    #   speakers: [
    #     %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
    #     %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
    #     %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
    #     %{name: "Filipe Felício", photo: "luis", job: "Organizer", company: "CeSIUM"},
    #     %{name: "Filipe Felício", photo: "luis", job: "Organizer", company: "CeSIUM"}
    #   ]
    # },
    # %{
    #   day: "30 de Junho",
    #   speakers: [
    #     %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
    #     %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
    #     %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
    #     %{name: "Filipe Felício", photo: "luis", job: "Organizer", company: "CeSIUM"},
    #     %{name: "Filipe Felício", photo: "luis", job: "Organizer", company: "CeSIUM"}
    #   ]
    # }
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:current_page, "Speakers")
     |> assign(:days, @days)}
  end
end
