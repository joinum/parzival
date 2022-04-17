defmodule ParzivalWeb.HomeController do
  use ParzivalWeb, :controller

  def index(conn, _params) do
    conn
     |> assign(:current_page, "home")
     |> render("index.html")
  end
end
