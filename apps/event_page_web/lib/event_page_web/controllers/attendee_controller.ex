defmodule EventPage.Web.AttendeeController do
  use EventPage.Web, :controller

  alias EventPage.PageContents
  alias EventPage.PageContents.Event
  alias EventPage.PageContents.Attendee

  plug :put_event when action in [:index, :new, :create, :show, :edit, :update]

  action_fallback EventPage.Web.FallbackController

  def index(conn, _params) do
    event = conn.assigns.event
    with attendees  <- PageContents.list_attendees(event.id) do
      conn |> render("index.html", event: event, attendees: attendees)
    end
  end

  def new(conn, _params) do
    event = conn.assigns.event
    attendee = %Attendee{page_contents_event_id: event.id}
    with changeset  <- PageContents.change_attendee(attendee) do
      conn |> render("new.html", event: event, changeset: changeset)
    end
  end

  def create(conn, %{"event_id" => event_id, "attendee" => attendee_params}) do
    attendee_params = attendee_params |> Map.put("page_contents_event_id", event_id)

    case PageContents.create_attendee(attendee_params) do
      {:ok, attendee} ->
        conn
        |> put_flash(:info, "Event Attendee create successfully.")
        |> redirect(to: attendee_path(conn, :show, attendee.page_contents_event_id, attendee))
      {:error, %Ecto.Changeset{} = changeset} ->
        event = conn.assigns.event
        conn |> render("new.html", event: event, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    with %Attendee{} = attendee  <- PageContents.get_attendee(id) do
      conn |> render("show.html", attendee: attendee)
    end
  end

  def edit(conn, %{"id" => id}) do
    attendee = PageContents.get_attendee!(id)
    changeset = PageContents.change_attendee(attendee)
    conn |> render("edit.html", attendee: attendee, changeset: changeset)
  end

  def update(conn, %{"event_id" => event_id, "id" => id, "attendee" => attendee_params}) do
    attendee = PageContents.get_attendee!(id)

    case PageContents.update_attendee(attendee, attendee_params) do
      {:ok, attendee} ->
        conn
        |> put_flash(:info, "Event Attendee updated successfully.")
        |> redirect(to: attendee_path(conn, :show, event_id, attendee))
      {:error, %Ecto.Changeset{} = changeset} ->
        event = conn.assigns.event
        render(conn, "edit.html", event: event, attendee: attendee, changeset: changeset)
    end
  end

  def delete(conn, %{"event_id" => event_id, "id" => id}) do
    with %Attendee{} = attendee <- PageContents.get_attendee(id),
          {:ok, _attendee} <- PageContents.delete_attendee(attendee) do
      conn
      |> put_flash(:info, "Event Attendee deleted successfully.")
      |> redirect(to: attendee_path(conn, :index, event_id))
    end
  end

  defp put_event(%{params: %{"event_id" => event_id}} = conn, _opts) do
    with %Event{} = event  <- PageContents.get_event(event_id) do
      conn |> assign(:event, event)
    end
  end

end
