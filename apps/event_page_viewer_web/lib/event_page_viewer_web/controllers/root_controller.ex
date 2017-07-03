defmodule EventPageViewer.Web.RootController do
  use EventPageViewer.Web, :controller

  alias EventPage.PageContents

  def index(conn, _params) do
    events = PageContents.list_events()
    render(conn, "index.html", events: events)
  end

end
