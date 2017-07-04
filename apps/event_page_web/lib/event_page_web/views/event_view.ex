defmodule EventPage.Web.EventView do
  use EventPage.Web, :view


  alias EventPage.Web.TabEmbedView
  alias EventPage.Web.AttendeeView

  def render("tab_embed_index_items.html", %{conn: conn, event: event, tab_embeds: tab_embeds}) do
    render(TabEmbedView, "index_items.html", %{conn: conn, event: event, tab_embeds: tab_embeds})
  end

  def render("attendee_index_items.html", %{conn: conn, event: event, attendees: attendees}) do
    render(AttendeeView, "index_items.html", %{conn: conn, event: event, attendees: attendees})
  end

end
