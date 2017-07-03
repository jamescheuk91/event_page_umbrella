defmodule EventPageViewer.Web.AttendeeController do
  use EventPageViewer.Web, :controller

  alias EventPage.PageContents
  alias EventPage.PageContents.Event

  def index(conn, %{"event_id" => event_id}) do
    with %Event{} = event <- PageContents.get_event(event_id),
          attendees <- PageContents.list_attendees(event.id) do
      conn
      |> render("index.html", event: event, attendees: attendees)
    end
  end

end
