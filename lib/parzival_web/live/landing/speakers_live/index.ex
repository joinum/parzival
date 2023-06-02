defmodule ParzivalWeb.Landing.SpeakersLive.Index do
  @moduledoc false
  use ParzivalWeb, [:live_view, {ParzivalWeb.LayoutView, "landing.html"}]

  require Integer

  @days [
    %{
      day: "5 de Junho",
      speakers: [
        %{
          name: "TBA",
          photo: "join",
          job: "",
          company: ""
        },
        %{
          name: "TBA",
          photo: "join",
          job: "",
          company: ""
        },
        %{
          name: "TBA",
          photo: "join",
          job: "",
          company: ""
        },
        %{
          name: "TBA",
          photo: "join",
          job: "",
          company: ""
        },
        %{
          name: "TBA",
          photo: "join",
          job: "",
          company: ""
        },
        %{
          name: "TBA",
          photo: "join",
          job: "",
          company: ""
        }
      ]
    },
    %{
      day: "6 de Junho",
      speakers: [
        %{
          name: "TBA",
          photo: "join",
          job: "",
          company: ""
        },
        %{
          name: "TBA",
          photo: "join",
          job: "",
          company: ""
        },
        %{
          name: "TBA",
          photo: "join",
          job: "",
          company: ""
        },
        %{
          name: "TBA",
          photo: "join",
          job: "",
          company: ""
        },
        %{
          name: "TBA",
          photo: "join",
          job: "",
          company: ""
        }
      ]
    },
    %{
      day: "7 de Junho",
      speakers: [
        %{
          name: "TBA",
          photo: "join",
          job: "",
          company: ""
        },
        %{
          name: "TBA",
          photo: "join",
          job: "",
          company: ""
        },
        %{
          name: "TBA",
          photo: "join",
          job: "",
          company: ""
        }
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
