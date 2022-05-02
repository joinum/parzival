defmodule ParzivalWeb.Landing.TeamLive.Index do
  @moduledoc false
  use ParzivalWeb, [:live_view, {ParzivalWeb.LayoutView, "landing.html"}]

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

  @organizers ["cesium", "necc", "nefum", "di"]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:current_page, "Team")
     |> assign(:team, @team)
     |> assign(:organizers, @organizers)}
  end
end
