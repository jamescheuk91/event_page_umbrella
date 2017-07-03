defmodule EventPage.Repo.Migrations.CreateEventPage.PageContents.Attendee do
  use Ecto.Migration

  def change do
    create table(:page_contents_attendees) do
      add :name, :text
      add :title, :text
      add :description, :text
      add :avatar, :string

      add :page_contents_event_id, :integer

      timestamps()
    end
  end
end
