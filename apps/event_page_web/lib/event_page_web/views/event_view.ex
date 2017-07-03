defmodule EventPage.Web.EventView do
  use EventPage.Web, :view

  alias EventPage.Web.AttendeeView


  def render("attendees_index.html", %{attendees: attendees}) do
    render(AttendeeView, "index.html", %{attendees: attendees})
  end
end
