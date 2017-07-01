defmodule EventPage.Web.EventPageController do
  use EventPage.Web, :controller

  alias EventPage.Events

  def show(conn, _params) do
    event_detail = Events.get_event_detail!(1)

    conn
    |> put_layout({EventPage.Web.LayoutView, "event_page.html"})
    |> render("show.html", event_detail: event_detail)
  end

end
