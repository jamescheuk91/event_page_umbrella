# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :event_page_web,
  namespace: EventPage.Web,
  ecto_repos: [EventPage.Repo]

# Configures the endpoint
config :event_page_web, EventPage.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7VW5HLO7h/CXpL/4IsIL0+M7UCSkidOmgQOKLpioQUJigMBjzOWuaipjvboLYHdT",
  render_errors: [view: EventPage.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: EventPage.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :event_page_web, :generators,
  context_app: :event_page

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
