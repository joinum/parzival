defmodule ParzivalWeb.PageControllerTest do
  use ParzivalWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "5, 6 and 7 of June"
  end
end
