defmodule ParzivalWeb.PageControllerTest do
  use ParzivalWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "05, 06 e 07 de junho"
  end
end
