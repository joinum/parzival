defmodule ParzivalWeb.ScheduleController do
  use ParzivalWeb, :controller

  def index(conn, _params) do
    conn
     |> assign(:current_page, "schedule")
     |> render("index.html")
  end
end
