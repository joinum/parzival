defmodule ParzivalWeb.HomeController do
  use ParzivalWeb, :controller

  def index(conn, _params) do

    schedule = %{
      tuesday: [
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
      wednesday: [
        %{title: "INTEGRAÇÕES CONTÍNUAS", hours: ~N[2022-06-29 09:35:00.000000], speaker: "Tiago Gomes", company: "Vilt"},
        %{title: "O FANTÁSTICO MUNDO DO FRONTEND", hours: ~N[2022-06-29 10:20:00.000000], speaker: "Bruno Lourenço", company: nil},
        %{title: "COFFEE BREAK", hours: ~N[2022-06-29 11:05:00.000000], speaker: nil, company: nil},
        %{title: "SHIFTING TO MICROSERVICES IN THE REAL WORLD", hours: ~N[2022-06-29 11:35:00.000000], speaker: "Luís Barbosa e Hugo Neto", company: "360 Imprimir"},
        %{title: "ALMOÇO", hours: ~N[2022-06-29 12:20:00.000000], speaker: nil, company: nil},
        %{title: "CONTINUOUS DELIVERY", hours: ~N[2022-06-29 14:30:00.000000], speaker: "Pedro Costa", company: nil},
        %{title: "O QUE AS EMPRESAS ESPERAM DE UM WEB DEVELOPER", hours: ~N[2022-06-29 15:20:00.000000], speaker: "Daniela Costa", company: "Eurotux"},
        %{title: "ARE U A TECH BFF?", hours: ~N[2022-06-29 15:40:00.000000], speaker: "Jorge Ribeiro e Hugo Lourenço", company: "Primavera BSS"},
        %{title: "COFFEE BREAK", hours: ~N[2022-06-29 16:00:00.000000], speaker: nil, company: nil},
        %{title: "PITCH", hours: ~N[2022-06-29 16:30:00.000000], speaker: "Pedro Alves", company: "Wintouch"},
        %{title: "PITCH", hours: ~N[2022-06-29 16:40:00.000000], speaker: "Joana Gonçalves", company: "IT Sector"},
        %{title: "PITCH", hours: ~N[2022-06-29 16:50:00.000000], speaker: "Cláudia Gonçalves, Vasco Bessa", company: "Gfi Portugal"},
        %{title: "PITCH", hours: ~N[2022-06-29 17:10:00.000000], speaker: "Gabriela Moura", company: "Inova-Ria"},
        %{title: "PITCH", hours: ~N[2022-06-29 17:20:00.000000], speaker: "Carlos Viana", company: "GO Contact"},
        %{title: "SUNSET", hours: ~N[2022-06-29 18:30:00.000000], speaker: "Restaurante Panorâmico", company: nil},
      ],
      thursday: [
        %{title: "COMPUTER VISION- APTIV PRODUCTS AND PROCESS.", hours: ~N[2022-06-30 10:00:00.000000], speaker: "Luis Costa", company: "Aptiv"},
        %{title: "COMPUTAÇÃO VISUAL PARA A INDÚSTRIA 4.0", hours: ~N[2022-06-30 10:20:00.000000], speaker: "Nuno Sousa", company: nil},
        %{title: "COFFEE BREAK", hours: ~N[2022-06-30 11:05:00.000000], speaker: nil, company: nil},
        %{title: "THE ILLUSION OF LIFE- MAKING 'THEBREADWINNER'", hours: ~N[2022-06-30 11:35:00.000000], speaker: "João Martins", company: "Smith Micro"},
        %{title: "ALMOÇO", hours: ~N[2022-06-30 12:20:00.000000], speaker: nil, company: nil},
        %{title: "A ÁREA DA COMPUTAÇÃO GRÁFICA E OS SEUS ATUAIS DESAFIOS", hours: ~N[2022-06-30 14:30:00.000000], speaker: "António Ramires Fernandes", company: nil},
        %{title: "TBA", hours: ~N[2022-06-30 15:20:00.000000], speaker: "TBA", company: "Outsystems"},
        %{title: "TBA", hours: ~N[2022-06-30 15:40:00.000000], speaker: "TBA", company: "Ordem dos Engenheiros - Região Norte"},
        %{title: "COFFEE BREAK", hours: ~N[2022-06-30 16:00:00.000000], speaker: nil, company: nil},
        %{title: "PITCH", hours: ~N[2022-06-30 16:30:00.000000], speaker: "Filipe Ferreira", company: "Fujitsu"},
        %{title: "PITCH", hours: ~N[2022-06-30 16:40:00.000000], speaker: "Isabel Martins, Tiago Largato", company: "Johnson Controls"},
        %{title: "PITCH", hours: ~N[2022-06-30 16:50:00.000000], speaker: "TBA", company: "Logic Info"},
        %{title: "PITCH", hours: ~N[2022-06-30 17:10:00.000000], speaker: "Helena Castro", company: "EBanKit"},
        %{title: "PITCH", hours: ~N[2022-06-30 17:20:00.000000], speaker: "Ricardo Lopes", company: "Fast-mp - Live Marketplace"},
        %{title: "PITCH", hours: ~N[2022-06-30 17:30:00.000000], speaker: "TBA", company: "Konk Consulting"},
      ]
    }

    sponsors = [
      ["Cesium"],
      ["Cesium", "Cesium", "Cesium", "Cesium", "Cesium"],
      ["Cesium", "Cesium", "Cesium", "Cesium", "Cesium", "Cesium", "Cesium"],
      ["Cesium", "Cesium", "Cesium", "Cesium", "Cesium", "Cesium", "Cesium", "Cesium", "Cesium", "Cesium", "Cesium", "Cesium"]
    ]

    sponsors_table = sponsors
        |> Stream.with_index
        |> Enum.reduce([[], []], fn ({x, i}, [evens, odds]) ->
          case rem(i, 2) do
            0 -> [evens ++ [x], odds]
            _ -> [evens, odds ++ [x]]
          end
        end)

    speakers = [
      %{name: "Luis Araújo", job: "Slave", company: "CeSIUM"},
      %{name: "Luis Araújo", job: "Slave", company: "CeSIUM"},
      %{name: "Luis Araújo", job: "Slave", company: "CeSIUM"},
      %{name: "Filipe Felício", job: "Slave", company: "CeSIUM"},
      %{name: "Filipe Felício", job: "Slave", company: "CeSIUM"},
      %{name: "Filipe Felício", job: "Slave", company: "CeSIUM"},
    ]

    partners = ["Haribo","Haribo","Haribo","Haribo"]

    conn
     |> assign(:current_page, "home")
     |> assign(:schedule, schedule)
     |> assign(:sponsors, sponsors)
     |> assign(:sponsors_table, sponsors_table)
     |> assign(:speakers, speakers)
     |> assign(:partners, partners)
     |> render("index.html")
  end

  def get_next_activity(schedule, day) do
    now = NaiveDateTime.utc_now()

    schedule
      |> Map.get(day)
      |> Enum.reduce([], fn x, acc -> if NaiveDateTime.compare(now, x.hours) == :lt do acc ++ [x.hours] else acc end end)
      |> Enum.min_by(&abs(NaiveDateTime.diff(&1,now)))
  end
end
