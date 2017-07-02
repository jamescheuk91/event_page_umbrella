defmodule EventPageViewer.Web.RootController do
  use EventPageViewer.Web, :controller

  alias EventPage.Events

  def index(conn, _params) do
    events = Events.list_event_details()
    render(conn, "index.html", events: events)
  end

end
