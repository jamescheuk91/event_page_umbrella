defmodule EventPageViewer.Web.HomePageView do
  use EventPageViewer.Web, :view

  def page_title(:show, assigns), do: assigns[:event].name
end
