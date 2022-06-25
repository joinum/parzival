defmodule ParzivalWeb.Landing.ScheduleLive.Index do
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

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:current_page, "Schedule")
     |> assign(:schedule, @schedule)}
  end
end
