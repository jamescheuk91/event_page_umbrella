defmodule EventPage.Web.EventController do
  use EventPage.Web, :controller

  alias EventPage.Events
  alias EventPage.Events.EventDetail

  # plug :put_event_detail when action in [:show]

  action_fallback EventPage.Web.FallbackController

  def index(conn, _params) do
    event_details = Events.list_event_details()
    render(conn, "index.html", event_details: event_details)
  end

  def new(conn, _params) do
    changeset = Events.change_event_detail(%EventPage.Events.EventDetail{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event_detail" => event_detail_params}) do
    case Events.create_event_detail(event_detail_params) do
      {:ok, event_detail} ->
        conn
        |> put_flash(:info, "Event detail created successfully.")
        |> redirect(to: event_path(conn, :show, event_detail))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    with %EventDetail{} = event_detail <- Events.get_event_detail(id) do
      conn |> render("show.html", event_detail: event_detail)
    end
  end

  def edit(conn, %{"id" => id}) do
    event_detail = Events.get_event_detail!(id)
    changeset = Events.change_event_detail(event_detail)
    render(conn, "edit.html", event_detail: event_detail, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event_detail" => event_detail_params}) do
    event_detail = Events.get_event_detail!(id)

    case Events.update_event_detail(event_detail, event_detail_params) do
      {:ok, event_detail} ->
        conn
        |> put_flash(:info, "Event detail updated successfully.")
        |> redirect(to: event_path(conn, :show, event_detail))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event_detail: event_detail, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    with %EventDetail{} = event_detail <- Events.get_event_detail(id),
          {:ok, _event_detail} <- Events.delete_event_detail(event_detail) do
      conn
      |> put_flash(:info, "Event detail deleted successfully.")
      |> redirect(to: event_path(conn, :index))
    end
  end
end
