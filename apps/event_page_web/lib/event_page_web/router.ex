defmodule EventPage.Web.Router do
  use EventPage.Web, :router

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

  scope "/", EventPage.Web do
    pipe_through :browser # Use the default browser stack

    get "/", RootController, :index
    get "/heartbeat", RootController, :heartbeat

    resources "/event_details", EventDetailController
  end

  # Other scopes may use custom stacks.
  # scope "/api", EventPage.Web do
  #   pipe_through :api
  # end
end