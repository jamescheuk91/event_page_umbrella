use Mix.Config

config :event_page, ecto_repos: [EventPage.Repo]

config :arc,
  storage: Arc.Storage.Local


import_config "#{Mix.env}.exs"
