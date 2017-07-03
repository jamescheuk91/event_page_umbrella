defmodule EventPageViewer.Web.RootControllerTest do
  use EventPageViewer.Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to EventPageViewer!"
  end
end
