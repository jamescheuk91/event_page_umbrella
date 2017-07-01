defmodule EventPage.Events.EventDetail do
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset
  alias EventPage.Events.EventDetail
  alias EventPage.Web.BannerUploader


  schema "events_event_details" do
    field :description, :string
    field :name, :string
    field :banner, BannerUploader.Type

    timestamps()
  end

  @doc false
  def changeset(%EventDetail{} = event_detail, attrs) do
    event_detail
    |> cast(attrs, [:name, :description])
    |> cast_attachments(attrs, [:banner])
    |> validate_required([:name, :description, :banner])
    |> validate_length(:name, min: 3, max: 100)
    |> validate_length(:description, min: 3, max: 500)
  end
end
