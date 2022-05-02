defmodule ParzivalWeb.Landing.SpeakersLive.Index do
  @moduledoc false
  use ParzivalWeb, [:live_view, {ParzivalWeb.LayoutView, "landing.html"}]

  require Integer

  @days [
    %{
      day: "28 de Junho",
      speakers: [
        %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
        %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
        %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
        %{name: "Filipe Felício", photo: "luis", job: "Organizer", company: "CeSIUM"}
      ]
    },
    %{
      day: "29 de Junho",
      speakers: [
        %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
        %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
        %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
        %{name: "Filipe Felício", photo: "luis", job: "Organizer", company: "CeSIUM"},
        %{name: "Filipe Felício", photo: "luis", job: "Organizer", company: "CeSIUM"}
      ]
    },
    %{
      day: "30 de Junho",
      speakers: [
        %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
        %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
        %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
        %{name: "Filipe Felício", photo: "luis", job: "Organizer", company: "CeSIUM"},
        %{name: "Filipe Felício", photo: "luis", job: "Organizer", company: "CeSIUM"}
      ]
    }
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:current_page, "Speakers")
     |> assign(:days, @days)}
  end
end
