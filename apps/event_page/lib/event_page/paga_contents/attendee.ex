defmodule EventPage.PageContents.Attendee do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset
  alias EventPage.PageContents.Event
  alias EventPage.PageContents.Attendee
  alias EventPage.Web.AvatarUploader


  schema "page_contents_attendees" do
    field :name, :string
    field :title, :string
    field :description, :string
    field :avatar, AvatarUploader.Type
    belongs_to :event, Event, foreign_key: :page_contents_event_id

    timestamps()
  end

  @doc false
  def changeset(%Attendee{} = attendee, attrs) do
    attendee
    |> cast(attrs, [:name, :title, :description, :page_contents_event_id])
    |> cast_attachments(attrs, [:avatar], allow_paths: true)
    |> validate_required([:name, :title, :description])
    |> validate_length(:name, min: 3, max: 100)
    |> validate_length(:title, min: 3, max: 100)
    |> validate_length(:description, min: 3, max: 500)
  end
end
