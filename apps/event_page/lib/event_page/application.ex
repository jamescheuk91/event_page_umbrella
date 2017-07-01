defmodule EventPage.Application do
  @moduledoc """
  The EventPage Application Service.

  The event_page system business domain lives in this application.

  Exposes API to clients such as the `EventPage.Web` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(EventPage.Repo, []),
    ], strategy: :one_for_one, name: EventPage.Supervisor)
  end
end
