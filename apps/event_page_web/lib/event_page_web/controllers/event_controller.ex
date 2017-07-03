defmodule EventPage.Web.EventController do
  use EventPage.Web, :controller

  alias EventPage.PageContents
  alias EventPage.PageContents.Event

  @csv_headers [:name, :title, :description, :avatar]

  action_fallback EventPage.Web.FallbackController

  def index(conn, _params) do
    events = PageContents.list_events()
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = PageContents.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    event_params = event_params |> put_attendees_params

    case PageContents.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: event_path(conn, :show, event))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    with %Event{} = event <- PageContents.get_event(id),
          attendees <- PageContents.list_attendees(event.id) do
      conn |> render("show.html", event: event, attendees: attendees)
    end
  end

  def edit(conn, %{"id" => id}) do
    event = PageContents.get_event!(id)
    changeset = PageContents.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = PageContents.get_event!(id)
    event_params = event_params |> put_attendees_params

    case PageContents.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event detail updated successfully.")
        |> redirect(to: event_path(conn, :show, event))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    with %Event{} = event <- PageContents.get_event(id),
          {:ok, _event} <- PageContents.delete_event(event) do
      conn
      |> put_flash(:info, "Event deleted successfully.")
      |> redirect(to: event_path(conn, :index))
    end
  end

  defp put_attendees_params(params) do
    case params["attendee_list_file"] do
      nil -> params
      plug -> params |> Map.put_new("attendees", plug |> parse_csv_plug_file)
    end
  end

  # TODO: impl cast_csv marco in event.ex

  defp parse_csv_plug_file(%Plug.Upload{content_type: "text/csv", path: path}) do
    {_, list } = path
    |> File.stream!
    |> CSV.decode!(headers: @csv_headers, strip_fields: true)
    |> Enum.to_list
    |> List.pop_at(0)
    list
  end
end
