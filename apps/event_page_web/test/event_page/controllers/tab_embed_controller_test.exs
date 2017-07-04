defmodule EventPage.Web.TabEmbedControllerTest do
  use EventPage.Web.ConnCase

  alias EventPage.PageContents


  @create_attrs %{
    title: "some title", url: "https://riseconf.com/faq"
  }
  @update_attrs %{
    title: "some updated title", url: "https://riseconf.com/tickets"
  }
  @invalid_attrs %{title: nil, url: nil}

  def fixture(:event) do
    attrs = %{description: "some description", name: "some name",
      banner: %Plug.Upload{path: "test/fixtures/fixture_banner1.jpeg", filename: "fixture_banner1.jpeg"}
    }
    {:ok, event} = PageContents.create_event(attrs)
    event
  end

  def fixture(:tab_embed, event_id) do
    attrs = @create_attrs |> Map.put(:page_contents_event_id, event_id)
    {:ok, tab_embed} = PageContents.create_tab_embed(attrs)
    tab_embed
  end

  test "lists all entries on index", %{conn: conn} do
    event = fixture(:event)
    conn = get conn, tab_embed_path(conn, :index, event.id)
    assert html_response(conn, 200) =~ "Listing TabEmbeds"
  end

  test "renders chosen TabEmbeds", %{conn: conn} do
    event = fixture(:event)
    tab_embed = fixture(:tab_embed, event.id)

    conn = get conn, tab_embed_path(conn, :show, event.id, tab_embed.id)
    response = html_response(conn, 200)

    assert response =~ tab_embed.title
    assert response =~ tab_embed.url
  end

  test "renders form for new tab_embed", %{conn: conn} do
    event = fixture(:event)
    conn = get conn, tab_embed_path(conn, :new, event.id)
    assert html_response(conn, 200) =~ "New Event TabEmbed"
  end

  test "creates tab_embed and redirects to show when data is valid", %{conn: conn} do
    event = fixture(:event)
    conn = post conn, tab_embed_path(conn, :create, event.id), tab_embed: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == tab_embed_path(conn, :show, event.id, id)

    conn = get conn, tab_embed_path(conn, :show, event.id, id)
    response = html_response(conn, 200)

    assert response =~ "some title"
    assert response =~ "https://riseconf.com/faq"
  end

  test "does not create tab_embed and renders errors when data is invalid", %{conn: conn} do
    event = fixture(:event)
    conn = post conn, tab_embed_path(conn, :create, event.id), tab_embed: @invalid_attrs
    response = html_response(conn, 200)
    assert response =~ "New Event TabEmbed"
  end

  test "renders form for editing chosen tab_embed", %{conn: conn} do
    event = fixture(:event)
    tab_embed = fixture(:tab_embed, event.id)
    conn = get conn, tab_embed_path(conn, :edit, event.id, tab_embed.id)
    assert html_response(conn, 200) =~ "Edit #{tab_embed.title}"
  end

  test "updates chosen tab_embed and redirects when data is valid", %{conn: conn} do
    event = fixture(:event)
    tab_embed = fixture(:tab_embed, event.id)
    conn = put conn, tab_embed_path(conn, :update, event, tab_embed.id), tab_embed: @update_attrs
    assert redirected_to(conn) == tab_embed_path(conn, :show, event.id, tab_embed.id)

    conn = get conn, tab_embed_path(conn, :show, event.id, tab_embed.id)
    response = html_response(conn, 200)

    assert response =~ "some updated title"
    assert response =~ "https://riseconf.com/tickets"
  end

  test "does not update chosen tab_embed and renders errors when data is invalid", %{conn: conn} do
    event = fixture(:event)
    tab_embed = fixture(:tab_embed, event.id)
    conn = put conn, tab_embed_path(conn, :update, event.id, tab_embed.id), tab_embed: @invalid_attrs
    response = html_response(conn, 200)
    assert response =~ "Edit #{tab_embed.title}"
  end

  test "deletes chosen tab_embed", %{conn: conn} do
    event = fixture(:event)
    tab_embed = fixture(:tab_embed, event.id)
    conn = delete conn, tab_embed_path(conn, :delete, event.id, tab_embed.id)
    assert redirected_to(conn) == tab_embed_path(conn, :index, event.id)

    conn = get conn, tab_embed_path(conn, :show, event.id, tab_embed.id)
    assert html_response(conn, 404) =~ "Page Not Found"
  end

  test "render 404 tab_embed detail not found", %{conn: conn} do
    event = fixture(:event)
    id = 1
    conn = get conn, tab_embed_path(conn, :show, event.id, id)
    assert html_response(conn, 404) =~ "Page Not Found"
  end
end
