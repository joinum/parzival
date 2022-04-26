defmodule ParzivalWeb.MissionsController do
  use ParzivalWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:current_page, "Missions")
    |> render("index.html")
  end
end
