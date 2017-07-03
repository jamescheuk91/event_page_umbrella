defmodule EventPage.Web.EventView do
  use EventPage.Web, :view

  alias EventPage.Web.AttendeeView


  def render("attendee_index_items.html", %{conn: conn, event: event, attendees: attendees}) do
    render(AttendeeView, "index_items.html", %{conn: conn, event: event, attendees: attendees})
  end
end
