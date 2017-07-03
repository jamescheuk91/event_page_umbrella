defmodule EventPage.PageContents do
  @moduledoc """
  The boundary for the PageContents system.
  """

  import Ecto.Query, warn: false
  alias EventPage.Repo

  alias EventPage.PageContents.Event
  alias EventPage.PageContents.Attendee
  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Returns a event.
  ## Examples
    iex> get_event(123)
    %Event{}

    iex> get_event(456)
    nil
  """

  def get_event(id), do: Repo.get(Event, id)

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:attendees)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Repo.preload(:attendees)
    |> Event.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:attendees)
    |> Repo.update()
  end

  @doc """
  Deletes a Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end

  @doc """
  Returns the list of Attendees given a event id.

  ## Examples

      iex> list_attendees()
      [%Attendee{}, ...]

  """
  def list_attendees(evnet_id) do
    query = from a in Attendee, where: a.page_contents_event_id == ^evnet_id
    Repo.all(query)
  end

  @doc """
  Returns a attendee.
  ## Examples
    iex> get_attendee(123)
    %Event{}

    iex> get_attendee(456)
    nil
  """

  def get_attendee(id), do: Repo.get(Attendee, id)

  @doc """
  Gets a single attendee.

  Raises `Ecto.NoResultsError` if the attendee does not exist.

  ## Examples

      iex> get_attendee!(123)
      %Event{}

      iex> get_attendee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_attendee!(id), do: Repo.get!(Attendee, id)

  @doc """
  Creates a attendee.

  ## Examples

      iex> create_attendee(%{field: value})
      {:ok, %Attendee{}}

      iex> create_attendee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_attendee(attrs \\ %{}) do
    %Attendee{}
    |> Attendee.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a Attendee.

  ## Examples

      iex> update_attendee(attendee, %{field: new_value})
      {:ok, %Attendee{}}

      iex> update_attendee(attendee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_attendee(%Attendee{} = attendee, attrs) do
    attendee
    |> Attendee.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Attendee.

  ## Examples

      iex> delete_attendee(attendee)
      {:ok, %Event{}}

      iex> delete_attendee(attendee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_attendee(%Attendee{} = attendee) do
    Repo.delete(attendee)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking attendee changes.

  ## Examples

      iex> change_attendee(attendee)
      %Ecto.Changeset{source: %Attendee{}}

  """
  def change_attendee(%Attendee{} = attendee) do
    Attendee.changeset(attendee, %{})
  end
end
