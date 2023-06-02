defmodule ParzivalWeb.Landing.HomeLive.Index do
  @moduledoc false
  use ParzivalWeb, [:live_view, {ParzivalWeb.LayoutView, "landing.html"}]

  import ParzivalWeb.Components.WorkshopButton

  @schedule Jason.decode!(File.read!("data/schedule.json"))
            |> Enum.map(fn {key, value} ->
              {key,
               Enum.map(value, fn x ->
                 update_in(x, ["hours"], &Timex.parse!(&1, "{0D}/{0M}/{YYYY} {h12}:{m} {AM}"))
               end)}
            end)
            |> Enum.into(%{})

  @sponsors Jason.decode!(File.read!("data/sponsors.json"))

  @speakers Jason.decode!(File.read!("data/speakers.json"))

  @sponsors_table @sponsors
                  |> Stream.with_index()
                  |> Enum.reduce([[], []], fn {x, i}, [evens, odds] ->
                    case rem(i, 2) do
                      0 -> [evens ++ [x], odds]
                      _ -> [evens, odds ++ [x]]
                    end
                  end)

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:current_page, "Home")
     |> assign(:schedule, @schedule)
     |> assign(:sponsors, @sponsors)
     |> assign(:sponsors_table, @sponsors_table)
     |> assign(:speakers, @speakers)
     |> assign(:partners, [])}
  end
end
