defmodule EventPage.Web.RootController do
  use EventPage.Web, :controller

  def index(conn, _params) do
    conn |> render("index.html")
  end

  def heartbeat(conn, _params) do
    conn |> send_resp(200, "OK")
  end
end
