defmodule EventPage.Web.EventControllerTest do
  use EventPage.Web.ConnCase

  alias EventPage.Events


  @create_attrs %{description: "some description", name: "some name",
    banner: %Plug.Upload{path: "test/fixtures/fixture_banner1.jpeg", filename: "fixture_banner1.jpeg"}
  }
  @update_attrs %{description: "some updated description", name: "some updated name",
    banner: %Plug.Upload{path: "test/fixtures/fixture_banner2.jpeg", filename: "fixture_banner1.jpeg"}
  }
  @invalid_attrs %{description: nil, name: nil}

  def fixture(:event_detail) do
    {:ok, event_detail} = Events.create_event_detail(@create_attrs)
    event_detail
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, event_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Events"
  end

  test "renders form for new event_details", %{conn: conn} do
    conn = get conn, event_path(conn, :new)
    assert html_response(conn, 200) =~ "New Event"
  end

  test "creates event_detail and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, event_path(conn, :create), event_detail: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == event_path(conn, :show, id)

    conn = get conn, event_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Event detail"
  end

  test "does not create event_detail and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, event_path(conn, :create), event_detail: @invalid_attrs
    assert html_response(conn, 200) =~ "New Event"
  end

  test "renders form for editing chosen event_detail", %{conn: conn} do
    event_detail = fixture(:event_detail)
    conn = get conn, event_path(conn, :edit, event_detail)
    assert html_response(conn, 200) =~ "Edit #{event_detail.name}"
  end

  test "updates chosen event_detail and redirects when data is valid", %{conn: conn} do
    event_detail = fixture(:event_detail)
    conn = put conn, event_path(conn, :update, event_detail), event_detail: @update_attrs
    assert redirected_to(conn) == event_path(conn, :show, event_detail)

    conn = get conn, event_path(conn, :show, event_detail)
    assert html_response(conn, 200) =~ "some updated description"
  end

  test "does not update chosen event_detail and renders errors when data is invalid", %{conn: conn} do
    event_detail = fixture(:event_detail)
    conn = put conn, event_path(conn, :update, event_detail), event_detail: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit #{event_detail.name}"
  end

  test "deletes chosen event_detail", %{conn: conn} do
    event_detail = fixture(:event_detail)
    conn = delete conn, event_path(conn, :delete, event_detail)
    assert redirected_to(conn) == event_path(conn, :index)

    conn = get conn, event_path(conn, :show, event_detail)
    assert html_response(conn, 404) =~ "Page Not Found"
  end

  test "render 404 event detail not found", %{conn: conn} do
    id = 1
    conn = get conn, event_path(conn, :show, id)
    assert html_response(conn, 404) =~ "Page Not Found"
  end
end
