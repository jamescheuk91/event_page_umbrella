defmodule EventPage.Web.AttendeeControllerTest do
  use EventPage.Web.ConnCase

  alias EventPage.PageContents


  @create_attrs %{description: "some description", name: "some name", title: "some title",
    avatar: %Plug.Upload{path: "test/fixtures/fixture_banner1.jpeg", filename: "fixture_banner1.jpeg"}
  }
  @update_attrs %{description: "some updated description", name: "some updated name", title: "some updated title",
    banner: %Plug.Upload{path: "test/fixtures/fixture_banner2.jpeg", filename: "fixture_banner1.jpeg"}
  }
  @invalid_attrs %{description: nil, name: nil}

  def fixture(:event) do
    attrs = %{description: "some description", name: "some name",
      banner: %Plug.Upload{path: "test/fixtures/fixture_banner1.jpeg", filename: "fixture_banner1.jpeg"}
    }
    {:ok, event} = PageContents.create_event(attrs)
    event
  end

  def fixture(:attendee, event_id) do
    attrs = @create_attrs |> Map.put(:page_contents_event_id, event_id)
    {:ok, attendee} = PageContents.create_attendee(attrs)
    attendee
  end

  test "lists all entries on index", %{conn: conn} do
    event = fixture(:event)
    conn = get conn, attendee_path(conn, :index, event.id)
    assert html_response(conn, 200) =~ "Listing Attendees"
  end

  test "renders chosen Attendees", %{conn: conn} do
    event = fixture(:event)
    attendee = fixture(:attendee, event.id)

    conn = get conn, attendee_path(conn, :show, event.id, attendee.id)
    response = html_response(conn, 200)

    assert response =~ attendee.name
    assert response =~ attendee.title
    assert response =~ attendee.description
  end

  test "renders form for new attendee", %{conn: conn} do
    event = fixture(:event)
    conn = get conn, attendee_path(conn, :new, event.id)
    assert html_response(conn, 200) =~ "New Event Attendee"
  end

  test "creates attendee and redirects to show when data is valid", %{conn: conn} do
    event = fixture(:event)
    conn = post conn, attendee_path(conn, :create, event.id), attendee: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == attendee_path(conn, :show, event.id, id)

    conn = get conn, attendee_path(conn, :show, event.id, id)
    response = html_response(conn, 200)

    assert response =~ "some name"
    assert response =~ "some title"
    assert response =~ "some description"
  end

  test "does not create attendee and renders errors when data is invalid", %{conn: conn} do
    event = fixture(:event)
    conn = post conn, attendee_path(conn, :create, event.id), attendee: @invalid_attrs
    response = html_response(conn, 200)
    assert response =~ "New Event Attendee"
  end

  test "renders form for editing chosen attendee", %{conn: conn} do
    event = fixture(:event)
    attendee = fixture(:attendee, event.id)
    conn = get conn, attendee_path(conn, :edit, event.id, attendee.id)
    assert html_response(conn, 200) =~ "Edit #{attendee.name}"
  end

  test "updates chosen attendee and redirects when data is valid", %{conn: conn} do
    event = fixture(:event)
    attendee = fixture(:attendee, event.id)
    conn = put conn, attendee_path(conn, :update, event, attendee.id), attendee: @update_attrs
    assert redirected_to(conn) == attendee_path(conn, :show, event.id, attendee.id)

    conn = get conn, attendee_path(conn, :show, event.id, attendee.id)
    response = html_response(conn, 200)

    assert response =~ "some updated name"
    assert response =~ "some updated title"
    assert response =~ "some updated description"
  end

  test "does not update chosen attendee and renders errors when data is invalid", %{conn: conn} do
    event = fixture(:event)
    attendee = fixture(:attendee, event.id)
    conn = put conn, attendee_path(conn, :update, event.id, attendee.id), attendee: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit #{attendee.name}"
  end

  test "deletes chosen attendee", %{conn: conn} do
    event = fixture(:event)
    attendee = fixture(:attendee, event.id)
    conn = delete conn, attendee_path(conn, :delete, event.id, attendee.id)
    assert redirected_to(conn) == attendee_path(conn, :index, event.id)

    conn = get conn, attendee_path(conn, :show, event.id, attendee.id)
    assert html_response(conn, 404) =~ "Page Not Found"
  end

  test "render 404 attendee detail not found", %{conn: conn} do
    event = fixture(:event)
    id = 1
    conn = get conn, attendee_path(conn, :show, event.id, id)
    assert html_response(conn, 404) =~ "Page Not Found"
  end
end
