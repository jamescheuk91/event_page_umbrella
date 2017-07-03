defmodule EventPageViewer.Web.AttendeeController do
  use EventPageViewer.Web, :controller

  alias EventPage.PageContents
  alias EventPage.PageContents.Event

  def show(conn, %{"id" => id}) do
    with %Event{} = event <- PageContents.get_event(id),
          attendees <- PageContents.list_attendees(event.id) do
      conn
      |> render("show.html", event: event, attendees: attendees)
    end
  end

end
