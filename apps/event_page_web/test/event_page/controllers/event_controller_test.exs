defmodule EventPage.Web.EventControllerTest do
  use EventPage.Web.ConnCase

  alias EventPage.PageContents


  @create_attrs %{description: "some description", name: "some name",
    banner: %Plug.Upload{path: "test/fixtures/fixture_banner1.jpeg", filename: "fixture_banner1.jpeg"},
    attendee_list_file: %Plug.Upload{content_type: "text/csv", path: "test/fixtures/rise_conf_attendee_list.csv"}
  }
  @update_attrs %{description: "some updated description", name: "some updated name",
    banner: %Plug.Upload{path: "test/fixtures/fixture_banner2.jpeg", filename: "fixture_banner1.jpeg"}
  }
  @invalid_attrs %{description: nil, name: nil}

  def fixture(:event) do
    {:ok, event} = PageContents.create_event(@create_attrs)
    event
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, event_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Events"
  end

  test "renders chosen event", %{conn: conn} do
    event = fixture(:event)
    conn = get conn, event_path(conn, :show, event.id)
    response = html_response(conn, 200)
    assert response =~ event.name
    assert response =~ event.description
  end

  test "renders form for new events", %{conn: conn} do
    conn = get conn, event_path(conn, :new)
    assert html_response(conn, 200) =~ "New Event"
  end

  test "creates event and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, event_path(conn, :create), event: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == event_path(conn, :show, id)

    conn = get conn, event_path(conn, :show, id)
    response = html_response(conn, 200)
    assert response =~ @create_attrs.name
    assert response =~ "Gary Vaynerchuk"
  end

  test "does not create event and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, event_path(conn, :create), event: @invalid_attrs
    assert html_response(conn, 200) =~ "New Event"
  end

  test "renders form for editing chosen event", %{conn: conn} do
    event = fixture(:event)
    conn = get conn, event_path(conn, :edit, event)
    assert html_response(conn, 200) =~ "Edit #{event.name}"
  end

  test "updates chosen event and redirects when data is valid", %{conn: conn} do
    event = fixture(:event)
    conn = put conn, event_path(conn, :update, event), event: @update_attrs
    assert redirected_to(conn) == event_path(conn, :show, event)

    conn = get conn, event_path(conn, :show, event)
    assert html_response(conn, 200) =~ "some updated description"
  end

  test "does not update chosen event and renders errors when data is invalid", %{conn: conn} do
    event = fixture(:event)
    conn = put conn, event_path(conn, :update, event), event: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit #{event.name}"
  end

  test "deletes chosen event", %{conn: conn} do
    event = fixture(:event)
    conn = delete conn, event_path(conn, :delete, event)
    assert redirected_to(conn) == event_path(conn, :index)

    conn = get conn, event_path(conn, :show, event)
    assert html_response(conn, 404) =~ "Page Not Found"
  end

  test "render 404 event detail not found", %{conn: conn} do
    id = 1
    conn = get conn, event_path(conn, :show, id)
    assert html_response(conn, 404) =~ "Page Not Found"
  end
end
