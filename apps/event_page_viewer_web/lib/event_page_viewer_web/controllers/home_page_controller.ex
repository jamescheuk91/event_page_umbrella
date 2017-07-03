defmodule EventPageViewer.Web.HomePageController do
  use EventPageViewer.Web, :controller

  alias EventPage.PageContents
  alias EventPage.PageContents.Event

  def show(conn, %{"id" => id}) do
    with %Event{} = event <- PageContents.get_event(id) do
      conn
      |> render("show.html", event: event)
    end
  end

end
