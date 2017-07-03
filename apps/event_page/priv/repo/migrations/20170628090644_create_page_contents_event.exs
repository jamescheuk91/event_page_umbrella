defmodule EventPage.Repo.Migrations.CreateEventPage.PageContents.Event do
  use Ecto.Migration

  def change do
    create table(:page_contents_events) do
      add :name, :text
      add :description, :text

      timestamps()
    end

  end
end
