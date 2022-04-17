defmodule ParzivalWeb.FaqsController do
  use ParzivalWeb, :controller

  alias Parzival.Tools

  def index(conn, _params) do
    conn
    |> assign(:faqs, Tools.list_faqs())
    |> render("index.html")
  end
end
