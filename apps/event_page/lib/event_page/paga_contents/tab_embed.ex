defmodule EventPage.PageContents.TabEmbed do
  use Ecto.Schema
  import Ecto.Changeset
  alias EventPage.PageContents.Event
  alias EventPage.PageContents.TabEmbed

  schema "page_contents_tab_embeds" do
    field :title, :string
    field :url,   :string

    belongs_to :event, Event, foreign_key: :page_contents_event_id

    timestamps()
  end

  @doc false
  def changeset(%TabEmbed{} = tag_embed, attrs) do
    tag_embed
    |> cast(attrs, [:title, :url, :page_contents_event_id])
    |> validate_required([:title, :url])
    |> validate_length(:title, min: 3, max: 20)
  end
end
