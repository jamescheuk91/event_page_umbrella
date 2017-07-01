defmodule EventPageViewer.Web.EventPageView do
  use EventPageViewer.Web, :view


  def page_title(:show, assigns), do: assigns[:event_detail].name

end
