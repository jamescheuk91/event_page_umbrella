defmodule EventPageViewer.Web.TabEmbedPageController do
  use EventPageViewer.Web, :controller

  alias EventPage.PageContents
  alias EventPage.PageContents.Event

  def show(conn, %{"event_id" => event_id, "title" => title}) do

    with %Event{} = event <- PageContents.get_event(event_id, preload: [:tab_embeds]),
          tab_embed <- PageContents.get_tab_embed(event_id, title) do
      conn
      |> render("show.html", event: event, tab_embeds: event.tab_embeds, tab_embed: tab_embed)
    end
  end

end
