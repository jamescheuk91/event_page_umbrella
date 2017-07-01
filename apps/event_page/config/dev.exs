use Mix.Config

# Configure your database
config :event_page, EventPage.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "event_page_dev",
  hostname: "localhost",
  pool_size: 10
