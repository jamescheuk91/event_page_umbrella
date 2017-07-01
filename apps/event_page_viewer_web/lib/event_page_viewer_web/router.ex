defmodule EventPageViewer.Web.Router do
  use EventPageViewer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :event_page_layout do
    plug :put_layout, {EventPageViewer.Web.EventLayoutView, "app.html"}
  end


  scope "/", EventPageViewer.Web do
    pipe_through :browser # Use the default browser stack

    get "/", RootController, :index

    pipe_through :event_page_layout
    get "/:id", EventPageController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", EventPageViewer.Web do
  #   pipe_through :api
  # end
end
