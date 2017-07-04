defmodule EventPage.Repo.Migrations.CreateEventPage.PageContents.TabEmbed do
  use Ecto.Migration

  def change do
    create table(:page_contents_tab_embeds) do
      add :title, :text
      add :url,   :text

      add :page_contents_event_id, :integer

      timestamps()
    end
  end
end
