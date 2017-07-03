defmodule EventPage.PageContents.Event do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset
  alias EventPage.PageContents.Event
  alias EventPage.Web.BannerUploader


  schema "page_contents_events" do
    field :name, :string
    field :description, :string
    field :banner, BannerUploader.Type

    timestamps()
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:name, :description])
    |> cast_attachments(attrs, [:banner])
    |> validate_required([:name, :description, :banner])
    |> validate_length(:name, min: 3, max: 100)
    |> validate_length(:description, min: 3, max: 500)
  end
end
