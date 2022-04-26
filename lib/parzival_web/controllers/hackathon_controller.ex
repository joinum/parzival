defmodule ParzivalWeb.HackathonController do
  use ParzivalWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:current_page, "Hackathon")
    |> render("index.html")
  end
end
