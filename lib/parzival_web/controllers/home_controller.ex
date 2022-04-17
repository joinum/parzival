defmodule ParzivalWeb.HomeController do
  use ParzivalWeb, :controller

  def index(conn, _params) do
    event_dates = [~N[2022-06-28 09:00:00.000000],~N[2022-06-29 09:00:00.000000],~N[2022-06-30 09:00:00.000000]]

    schedule = [
      [
        %{title: "Sessão de abertura", hours: ~N[2022-06-28 09:15:00.000000], speaker: nil, company: nil},
        %{title: "How to orchestrate the Trading platform", hours: ~N[2022-06-28 10:00:00.000000], speaker: "Marco Machado", company: "Eurotux"},
        %{title: "WHAT IS A BLOCKCHAIN? UNDERSTANDING THE TECHNOLOGY, PURPOSE AND SCOPE.", hours: ~N[2022-06-28 10:20:00.000000], speaker: "Filipe Castro", company: nil},
        %{title: "COFFEE BREAK", hours: ~N[2022-06-28 11:05:00.000000], speaker: nil, company: nil},
        %{title: "AI @ ACCENTURE - RPA & CHATBOTS", hours: ~N[2022-06-28 11:35:00.000000], speaker: "Rui Pires", company: "Accenture"},
        %{title: "Almoço", hours: ~N[2022-06-28 12:20:00.000000], speaker: nil, company: nil},
        %{title: "BUILDING A BLOCKCHAIN", hours: ~N[2022-06-28 14:30:00.000000], speaker: "Miguel Palhas", company: nil},
        %{title: "CARS, THE NEXT BIG THING IN THE INTERNET OF THINGS", hours: ~N[2022-06-28 15:20:00.000000], speaker: "João Esteves", company: "Critical Techworks"},
        %{title: "COFFEE BREAK", hours: ~N[2022-06-28 16:00:00.000000], speaker: nil, company: nil},
        %{title: "PITCH", hours: ~N[2022-06-28 16:30:00.000000], speaker: "Luís Fernandes", company: "Bold"},
        %{title: "PITCH", hours: ~N[2022-06-28 16:40:00.000000], speaker: "Andreia Gonçalves", company: "Kwan"},
        %{title: "PITCH", hours: ~N[2022-06-28 16:50:00.000000], speaker: "André Silva", company: "Prime IT"},
        %{title: "PITCH", hours: ~N[2022-06-28 17:00:00.000000], speaker: "Inês Monteiro", company: "Aubay"},
        %{title: "PITCH", hours: ~N[2022-06-28 17:10:00.000000], speaker: "Ernesto Pedrosa", company: "Automaise"},
        %{title: "PITCH", hours: ~N[2022-06-28 17:20:00.000000], speaker: "Filipe Duarte", company: "Winprovit"},
      ],
      [],
      []
    ]

    conn
     |> assign(:current_page, "home")
     |> assign(:event_dates, event_dates)
     |> assign(:schedule, schedule)
     |> render("index.html")
  end
end
