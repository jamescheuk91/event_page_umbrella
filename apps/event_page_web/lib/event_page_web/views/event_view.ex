defmodule EventPage.Web.EventView do
  use EventPage.Web, :view
  
  alias EventPage.Web.EventDetailView

  def render("event_detail_show.html", %{event_detail: event_detail}) do
    render(EventDetailView, "show.html", %{event_detail: event_detail})
  end
end
