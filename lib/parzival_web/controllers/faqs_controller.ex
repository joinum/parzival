defmodule ParzivalWeb.FaqsController do
  use ParzivalWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
