defmodule EventPage.Repo.Migrations.AddBannerToEventPage.Events.EventDetail do
  use Ecto.Migration

  def change do
    alter table(:events_event_details) do
      add :banner, :string
    end
  end
end
