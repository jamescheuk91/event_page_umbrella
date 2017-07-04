defmodule EventPageViewer.Web.TabPageController do
  use EventPageViewer.Web, :controller

  alias EventPage.PageContents
  alias EventPage.PageContents.Event

  def show(conn, %{"event_id" => event_id}) do
    with %Event{} = event <- PageContents.get_event(event_id) do
      conn
      |> render("show.html", event: event)
    end
  end

end
