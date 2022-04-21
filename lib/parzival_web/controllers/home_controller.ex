defmodule ParzivalWeb.HomeController do
  use ParzivalWeb, :controller

  # @schedule Jason.decode!(File.read!("data/schedule.json"))

  @sponsors [
    ["cesium"],
    ["cesium", "cesium", "cesium", "cesium", "cesium"],
    ["cesium", "cesium", "cesium", "cesium", "cesium", "cesium", "cesium"],
    [
      "cesium",
      "cesium",
      "cesium",
      "cesium",
      "cesium",
      "cesium",
      "cesium",
      "cesium",
      "cesium",
      "cesium",
      "cesium",
      "cesium"
    ]
  ]

  @speakers [
    %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
    %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
    %{name: "Luis Araújo", photo: "luis", job: "Organizer", company: "CeSIUM"},
    %{name: "Filipe Felício", photo: "luis", job: "Organizer", company: "CeSIUM"},
    %{name: "Filipe Felício", photo: "luis", job: "Organizer", company: "CeSIUM"},
    %{name: "Filipe Felício", photo: "luis", job: "Organizer", company: "CeSIUM"}
  ]

  @partners ["Haribo", "Haribo", "Haribo", "Haribo"]

  @sponsors_table @sponsors
                  |> Stream.with_index()
                  |> Enum.reduce([[], []], fn {x, i}, [evens, odds] ->
                    case rem(i, 2) do
                      0 -> [evens ++ [x], odds]
                      _ -> [evens, odds ++ [x]]
                    end
                  end)

  def index(conn, _params) do
    conn
    |> assign(:current_page, "home")
    |> assign(:schedule, schedule())
    |> assign(:sponsors, @sponsors)
    |> assign(:sponsors_table, @sponsors_table)
    |> assign(:speakers, @speakers)
    |> assign(:partners, @partners)
    |> render("index.html")
  end
end
