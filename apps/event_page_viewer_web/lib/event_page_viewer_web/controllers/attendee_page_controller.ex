defmodule EventPageViewer.Web.AttendeePageController do
  use EventPageViewer.Web, :controller

  alias EventPage.PageContents
  alias EventPage.PageContents.Event

  def index(conn, %{"event_id" => event_id}) do
    with %Event{} = event <- PageContents.get_event(event_id, preload: [:tab_embeds, :attendees]) do
      conn
      |> render("index.html", event: event, tab_embeds: event.tab_embeds, attendees: event.attendees)
    end
  end

end
