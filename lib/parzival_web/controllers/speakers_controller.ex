defmodule ParzivalWeb.SpeakersController do
  use ParzivalWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:current_page, "speakers")
    |> render("index.html")
  end
end
