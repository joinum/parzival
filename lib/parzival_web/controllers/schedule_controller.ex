defmodule ParzivalWeb.ScheduleController do
  use ParzivalWeb, :controller

  @schedule Jason.decode!(File.read!("data/schedule.json"))
      |> Enum.map(fn ({key,value}) -> {key, Enum.map(value, fn x -> update_in(x, ["hours"], &(Timex.parse!(&1, "{0D}/{0M}/{YYYY} {h12}:{m} {AM}"))) end )} end)
      |> Enum.into(%{})

  def index(conn, _params) do

    conn
    |> assign(:current_page, "schedule")
    |> assign(:schedule, @schedule)
    |> render("index.html")
  end
end
