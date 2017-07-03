use Mix.Config

config :arc,
  storage: Arc.Storage.Local

# Configure your database
config :event_page, EventPage.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "event_page_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
