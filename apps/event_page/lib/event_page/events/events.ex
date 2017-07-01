defmodule EventPage.Events do
  @moduledoc """
  The boundary for the Events system.
  """

  import Ecto.Query, warn: false
  alias EventPage.Repo

  alias EventPage.Events.EventDetail

  @doc """
  Returns the list of event_details.

  ## Examples

      iex> list_event_details()
      [%EventDetail{}, ...]

  """
  def list_event_details do
    Repo.all(EventDetail)
  end

  @doc """
  Returns a event_detail.
  ## Examples
    iex> get_event_detail(123)
    %EventDetail{}

    iex> get_event_detail(456)
    nil
  """

  def get_event_detail(id), do: Repo.get(EventDetail, id)

  @doc """
  Gets a single event_detail.

  Raises `Ecto.NoResultsError` if the Event detail does not exist.

  ## Examples

      iex> get_event_detail!(123)
      %EventDetail{}

      iex> get_event_detail!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event_detail!(id), do: Repo.get!(EventDetail, id)

  @doc """
  Creates a event_detail.

  ## Examples

      iex> create_event_detail(%{field: value})
      {:ok, %EventDetail{}}

      iex> create_event_detail(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event_detail(attrs \\ %{}) do
    %EventDetail{}
    |> EventDetail.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event_detail.

  ## Examples

      iex> update_event_detail(event_detail, %{field: new_value})
      {:ok, %EventDetail{}}

      iex> update_event_detail(event_detail, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event_detail(%EventDetail{} = event_detail, attrs) do
    event_detail
    |> EventDetail.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a EventDetail.

  ## Examples

      iex> delete_event_detail(event_detail)
      {:ok, %EventDetail{}}

      iex> delete_event_detail(event_detail)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event_detail(%EventDetail{} = event_detail) do
    Repo.delete(event_detail)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event_detail changes.

  ## Examples

      iex> change_event_detail(event_detail)
      %Ecto.Changeset{source: %EventDetail{}}

  """
  def change_event_detail(%EventDetail{} = event_detail) do
    EventDetail.changeset(event_detail, %{})
  end
end
