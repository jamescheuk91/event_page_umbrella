defmodule EventPage.Web.RootControllerTest do
  use EventPage.Web.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to EventPage!"
  end

  test "GET /heartbeat", %{conn: conn} do
    conn = get conn, "/heartbeat"
    assert conn.status == 200
    assert conn.resp_body == "OK"
  end
end
