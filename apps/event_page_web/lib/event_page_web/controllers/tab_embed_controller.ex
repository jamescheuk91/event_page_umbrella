defmodule EventPage.Web.TabEmbedController do
  use EventPage.Web, :controller

  alias EventPage.PageContents
  alias EventPage.PageContents.Event
  alias EventPage.PageContents.TabEmbed


  plug :put_event when action in [:index, :new, :create, :show, :edit, :update]

  action_fallback EventPage.Web.FallbackController

  def index(conn, _params) do
    event = conn.assigns.event
    with tab_embeds <- PageContents.list_tab_embeds(event.id) do
      conn |> render("index.html", event: event, tab_embeds: tab_embeds)
    end
  end

  def new(conn, _params) do
    event = conn.assigns.event
    tab_embed = %TabEmbed{page_contents_event_id: event.id}
    with changeset <- PageContents.change_tab_embed(tab_embed) do
      conn |> render("new.html", event: event, changeset: changeset)
    end
  end

  def create(conn, %{"event_id" => event_id, "tab_embed" => tab_embed_params}) do
    tab_embed_params = tab_embed_params |> Map.put("page_contents_event_id", event_id)

    case PageContents.create_tab_embed(tab_embed_params) do
      {:ok, tab_embed} ->
        conn
        |> put_flash(:info, "Event TabEmbed create successfully.")
        |> redirect(to: tab_embed_path(conn, :show, tab_embed.page_contents_event_id, tab_embed))
      {:error, %Ecto.Changeset{} = changeset} ->
        event = conn.assigns.event
        conn |> render("new.html", event: event, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    with %TabEmbed{} = tab_embed <- PageContents.get_tab_embed(id) do
      conn |> render("show.html", tab_embed: tab_embed)
    end
  end

  def edit(conn, %{"id" => id}) do
    tab_embed = PageContents.get_tab_embed!(id)
    changeset = PageContents.change_tab_embed(tab_embed)
    conn |> render("edit.html", tab_embed: tab_embed, changeset: changeset)
  end

  def update(conn, %{"event_id" => event_id, "id" => id, "tab_embed" => tab_embed_params}) do
    tab_embed = PageContents.get_tab_embed!(id)

    case PageContents.update_tab_embed(tab_embed, tab_embed_params) do
      {:ok, tab_embed} ->
        conn
        |> put_flash(:info, "Event TabEmbed updated successfully.")
        |> redirect(to: tab_embed_path(conn, :show, event_id, tab_embed))
      {:error, %Ecto.Changeset{} = changeset} ->
        event = conn.assigns.event
        render(conn, "edit.html", event: event, tab_embed: tab_embed, changeset: changeset)
    end
  end

  def delete(conn, %{"event_id" => event_id, "id" => id}) do
    with %TabEmbed{} = tab_embed <- PageContents.get_tab_embed(id),
          {:ok, _tab_embed} <- PageContents.delete_tab_embed(tab_embed) do
      conn
      |> put_flash(:info, "Event TabEmbed deleted successfully.")
      |> redirect(to: tab_embed_path(conn, :index, event_id))
    end
  end

  defp put_event(%{params: %{"event_id" => event_id}} = conn, _opts) do
    with %Event{} = event <- PageContents.get_event(event_id) do
      conn |> assign(:event, event)
    end
  end


end
