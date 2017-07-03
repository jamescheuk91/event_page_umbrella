# EventPage.Umbrella

Requirement:
  * Erlang/OTP 19
  * Elixir 1.4.5
  * Nodejs v8.1.0
  * Postgresql


To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install ** cd ..`
  * Start Phoenix endpoint with `mix phx.server`

[`localhost:4000`](http://localhost:4001) for the Admin Page.
[`localhost:4001`](http://localhost:4000) for the Page Viewer.


Launch test watcher:
  * mix test.watch

Deployment:
  * mix edeliver build release production --verbose
  * mix edeliver deploy release to production —verbose
  * mix edeliver start production


http://139.59.96.210:8008 for the Admin Page
http://139.59.96.210:8080 for the Page Viewer
