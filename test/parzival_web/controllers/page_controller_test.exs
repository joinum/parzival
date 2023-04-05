defmodule ParzivalWeb.PageControllerTest do
  use ParzivalWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "28, 29 e 30 de junho"
  end
end
