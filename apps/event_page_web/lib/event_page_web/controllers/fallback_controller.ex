defmodule EventPage.Web.FallbackController do
  use EventPage.Web, :controller

  alias EventPage.Web.ErrorView

  def call(conn, nil) do
    conn |> not_found_fallback
  end

  def call(conn, {:error, Ecto.NoResultsError}) do
    conn |> not_found_fallback
  end

  defp not_found_fallback(conn) do
    conn
      |> put_status(:not_found)
      |> render(ErrorView, "404.html")
      |> halt
  end
end
