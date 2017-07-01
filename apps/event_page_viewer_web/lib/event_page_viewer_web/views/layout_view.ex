defmodule EventPageViewer.Web.LayoutView do
  use EventPageViewer.Web, :view


  def page_title(conn, assigns) do
    render_existing(view_module(conn), "page_title", Dict.put(assigns, :action_name, action_name(conn)))
      || default_page_title(conn, assigns)
  end

  def default_page_title(_conn, _assigns) do
    "Ticketee"
  end

end
