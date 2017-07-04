defmodule EventPage.PageContents do
  @moduledoc """
  The boundary for the PageContents system.
  """

  import Ecto.Query, warn: false
  alias EventPage.Repo

  alias EventPage.PageContents.Event
  alias EventPage.PageContents.TabEmbed
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
  Returns a event with opts.
  ## Examples
    iex> get_event(123, preload: [:tab_embeds, :attendees])
    %Event{}

    iex> get_event(456)
    nil
  """

  def get_event(id, opts) do
    Repo.get(Event, id)
    |> Repo.preload(opts[:preload])
  end

  @doc """
  Gets a single event .

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

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
  def create_event(attrs) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a event with opts.

  ## Examples

      iex> create_event(%{field: value}, cast_assocs: [:tab_embeds, :attendees])
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """


  def create_event(attrs, opts) do
    %Event{}
    |> Event.changeset(attrs)
    |> changeset_cast_assocs(opts[:assocs])
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
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value}, assocs: [:attendees, :tab_embeds])
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs, opts) do
    event
    |> repo_preload(opts[:assocs])
    |> Event.changeset(attrs)
    |> changeset_cast_assocs(opts[:assocs])
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
  Returns the list of Tab Embeds given a event id.

  ## Examples

      iex> list_tab_embeds(evnet_id)
      [%TabEmbed{}, ...]

  """
  def list_tab_embeds(evnet_id) do
    query = from t in TabEmbed, where: t.page_contents_event_id == ^evnet_id
    Repo.all(query)
  end

  @doc """
  Returns a TabEmbed.
  ## Examples
    iex> get_tab_embed(123)
    %Event{}

    iex> get_tab_embed(456)
    nil
  """

  def get_tab_embed(id), do: Repo.get(TabEmbed, id)

  @doc """
  Gets a TabEmbed.

  Raises `Ecto.NoResultsError` if the tab_embed does not exist.

  ## Examples

      iex> get_tab_embed!(123)
      %TabEmbed{}

      iex> get_tab_embed!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tab_embed!(id), do: Repo.get!(TabEmbed, id)

  @doc """
  Returns a TabEmbed by event_id and title.
  ## Examples
    iex> get_tab_embed(123, "title")
    %TabEmbed{}

    iex> get_tab_embed(456, "title")
    nil
  """

  def get_tab_embed(event_id, title) do
    query = from t in TabEmbed, where: t.page_contents_event_id == ^event_id and t.title == ^title
    Repo.one(query)
  end

  @doc """
  Creates a TabEmbed.

  ## Examples

      iex> create_tab_embed(%{field: value})
      {:ok, %TabEmbed{}}

      iex> create_tab_embed(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tab_embed(attrs \\ %{}) do
    %TabEmbed{}
    |> TabEmbed.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a TabEmbed.

  ## Examples

      iex> update_tab_embed(tab_embed, %{field: new_value})
      {:ok, %TabEmbed{}}

      iex> update_tab_embed(tab_embed, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tab_embed(%TabEmbed{} = tab_embed, attrs) do
    tab_embed
    |> TabEmbed.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TabEmbed.

  ## Examples

      iex> delete_tab_embed(tab_embed)
      {:ok, %TabEmbed{}}

      iex> delete_tab_embed(tab_embed)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tab_embed(%TabEmbed{} = tab_embed) do
    Repo.delete(tab_embed)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tab_embed changes.

  ## Examples

      iex> change_tab_embed(tab_embed)
      %Ecto.Changeset{source: %TabEmbed{}}

  """
  def change_tab_embed(%TabEmbed{} = tab_embed) do
    TabEmbed.changeset(tab_embed, %{})
  end

  @doc """
  Returns the list of Attendees given a event id.

  ## Examples

      iex> list_attendees(evnet_id)
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
    %Attendee{}

    iex> get_attendee(456)
    nil
  """

  def get_attendee(id), do: Repo.get(Attendee, id)

  @doc """
  Gets a single attendee.

  Raises `Ecto.NoResultsError` if the attendee does not exist.

  ## Examples

      iex> get_attendee!(123)
      %Attendee{}

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
      {:ok, %Attendee{}}

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

  defp repo_preload(struct, assocs) do
    Enum.reduce(assocs, struct, fn(assoc, acc_struct) ->
      acc_struct
      |> Repo.preload(assoc)
    end)
  end

  defp changeset_cast_assocs(changeset, assocs) do
    Enum.reduce(assocs, changeset, fn(assoc, acc_changeset) ->
      acc_changeset
      |> Ecto.Changeset.cast_assoc(assoc)
    end)
  end
end
