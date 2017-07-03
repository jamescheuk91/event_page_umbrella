defmodule EventPage.Repo.Migrations.AddBannerToEventPage.PageContents.Event do
  use Ecto.Migration

  def change do
    alter table(:page_contents_events) do
      add :banner, :string
    end
  end
end
