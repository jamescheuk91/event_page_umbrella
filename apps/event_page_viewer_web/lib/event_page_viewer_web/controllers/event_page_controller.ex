defmodule EventPageViewer.Web.EventPageController do
  use EventPageViewer.Web, :controller

  alias EventPage.Events
  alias EventPage.Events.EventDetail

  def show(conn, %{"id" => id}) do
    with %EventDetail{} = event_detail <- Events.get_event_detail(id) do

      conn
      |> render("show.html", event_detail: event_detail)
    end
  end

end
