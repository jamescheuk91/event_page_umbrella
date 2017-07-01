defmodule EventPage.Repo.Migrations.CreateEventPage.Events.EventDetail do
  use Ecto.Migration

  def change do
    create table(:events_event_details) do
      add :name, :text
      add :description, :text

      timestamps()
    end

  end
end
