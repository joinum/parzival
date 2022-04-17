defmodule ParzivalWeb.HackathonController do
  use ParzivalWeb, :controller

  def index(conn, _params) do
    conn
     |> assign(:current_page, "hackathon")
     |> render("index.html")
  end
end
