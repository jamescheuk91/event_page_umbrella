defmodule EventPage.PageContentsTest do
  use EventPage.DataCase, async: true

  alias EventPage.PageContents

  describe "events" do
    alias EventPage.PageContents.Event

    @fixture_banner_upload1 %Plug.Upload{path: "test/fixtures/fixture_banner1.jpeg", filename: "fixture_banner1.jpeg"}
    @fixture_banner_upload2 %Plug.Upload{path: "test/fixtures/fixture_banner2.jpeg", filename: "fixture_banner2.jpeg"}
    @valid_attrs %{
      description: "some description", name: "some name",
      banner: @fixture_banner_upload1
    }
    @update_attrs %{
      description: "some updated description", name: "some updated name",
      banner: @fixture_banner_upload2
    }
    @invalid_attrs %{description: nil, name: nil}

    def event_fixture(attrs \\ %{}) do
        attrs = attrs |> Enum.into(@valid_attrs)
        {:ok, event} = PageContents.create_event(attrs)
        event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert PageContents.list_events() == [event]
    end

    test "get_event/1 returns the event with given id" do
      event = event_fixture()
      assert PageContents.get_event(event.id) == event
    end

    test "get_event/1 returns nil with given id" do
      event_id = :rand.uniform(round(1.0e5))
      assert PageContents.get_event(event_id) == nil
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert PageContents.get_event!(event.id) == event
    end

    test "get_event/2 returns the event with given id" do
      event = event_fixture()
      _tab_embed = tab_embed_fixture(event.id)
      _attendee = attendee_fixture(event.id)

      fetched_event = PageContents.get_event(event.id, preload: [:tab_embeds, :attendees])
      assert Ecto.assoc_loaded?(fetched_event.tab_embeds)
      assert Ecto.assoc_loaded?(fetched_event.attendees)
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = PageContents.create_event(@valid_attrs)
      assert event.description == "some description"
      assert event.name == "some name"
    end

    test "create_event/1 with valid data, tab_embeds and attendees creates a event and tab_embeds" do
      tab_embeds = [%{title: "BOOK TICKETS", url: "https://riseconf.com/tickets"}]
      attendees = [%{description: "some description", name: "some name", title: "some title"}]
      attrs = @valid_attrs |> Map.put(:tab_embeds, tab_embeds) |> Map.put(:attendees, attendees)
      assert {:ok, %Event{} = event} = PageContents.create_event(attrs, assocs: [:tab_embeds, :attendees])

      assert event.tab_embeds == PageContents.list_tab_embeds(event.id)
      assert event.attendees == PageContents.list_attendees(event.id)
    end

    test "create_event/1 with invalid data returns error changeset (validate_required)" do
      expected_errors = [
        name: {"can't be blank", [validation: :required]},
        description: {"can't be blank", [validation: :required]}
      ]
      assert {:error, %Ecto.Changeset{} = changeset } = PageContents.create_event(@invalid_attrs)
      assert changeset.errors == expected_errors
    end

    test "create_event/1 with invalid data returns error changeset (validate_length min name description)" do
      invalid_name_lenght_attrs = %{name: "so", description: "s", banner: @fixture_banner_upload1}
      expected_errors = [
        description: {"should be at least %{count} character(s)", [count: 3, validation: :length, min: 3]},
        name: {"should be at least %{count} character(s)", [count: 3, validation: :length, min: 3]},
      ]
      assert {:error, %Ecto.Changeset{} = changeset} = PageContents.create_event(invalid_name_lenght_attrs)
      assert changeset.errors == expected_errors
    end

    test "create_event/1 with invalid data returns error changeset (validate_length max name description)" do
      fake_name = Faker.Lorem.sentence(%Range{first: 101, last: 1000})
      fake_description = Faker.Lorem.sentence(%Range{first: 1001, last: 5000})
      invalid_name_lenght_attrs = %{name: fake_name, description: fake_description, banner: @fixture_banner_upload1}
      expected_errors = [
        description: {"should be at most %{count} character(s)", [count: 1000, validation: :length, max: 1000]},
        name: {"should be at most %{count} character(s)", [count: 100, validation: :length, max: 100]},
      ]
      assert {:error, %Ecto.Changeset{} = changeset} = PageContents.create_event(invalid_name_lenght_attrs)
      assert changeset.errors == expected_errors
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, event} = PageContents.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.description == "some updated description"
      assert event.name == "some updated name"
    end

    test "update_event/2 with valid tab_embeds and attendees list updates the event" do
      event = event_fixture()
      tab_embeds = [%{title: "Book", url: "https://riseconf.com/tickets"}]
      attendees = [%{name: "attendee1 name", title: "attendee1 title", description: "attendee1 description"}]
      update_attrs = @update_attrs |> Map.put(:tab_embeds, tab_embeds) |> Map.put(:attendees, attendees)
      assert {:ok, event} = PageContents.update_event(event, update_attrs, assocs: [:attendees, :tab_embeds])
      assert %Event{} = event
      assert event.description == "some updated description"
      assert event.name == "some updated name"
      assert length(event.tab_embeds) == 1
      assert length(event.attendees) == 1
    end

    test "update_event/2 with invalid data returns error changeset  (validate_required)" do
      event = event_fixture()
      expected_errors = [
        name: {"can't be blank", [validation: :required]},
        description: {"can't be blank", [validation: :required]}
      ]
      assert {:error, %Ecto.Changeset{} = changeset } = PageContents.update_event(event, @invalid_attrs)
      assert changeset.errors == expected_errors

      assert event == PageContents.get_event!(event.id)
    end

    test "update_event/2 with invalid data returns error changeset  (validate_length name)" do
      invalid_name_lenght_attrs = %{name: "so", description: "some description", banner: @fixture_banner_upload1}
      event = event_fixture()
      expected_errors = [
        name: {"should be at least %{count} character(s)", [count: 3, validation: :length, min: 3]}
      ]
      assert {:error, %Ecto.Changeset{} = changeset} = PageContents.create_event(invalid_name_lenght_attrs)
      assert changeset.errors == expected_errors

      assert event == PageContents.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = PageContents.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> PageContents.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = PageContents.change_event(event)
    end
  end


  describe "tab_embeds" do
    alias EventPage.PageContents.Event
    alias EventPage.PageContents.TabEmbed

    @valid_attrs %{
      title: "some title", url: "https://riseconf.com/tickets"
    }

    @update_attrs %{
      title: "some updated title", url: "https://riseconf.com/faq"
    }

    @invalid_attrs %{title: nil, url: nil}

    setup do
      event = event_fixture()
      {:ok, event: event}
    end

    def tab_embed_fixture(event_id) do
      attrs = @valid_attrs |> Map.put(:page_contents_event_id, event_id)
      {:ok, attendee} = PageContents.create_tab_embed(attrs)
      attendee
    end

    test "list_tab_embeds/1 returns all tab_embeds given a evnet_id", %{event: event} do
      tab_embed = tab_embed_fixture(event.id)
      assert PageContents.list_tab_embeds(tab_embed.page_contents_event_id) == [tab_embed]
    end

    test "get_tab_embed/1 return the tab_embed with given id", %{event: event} do
      tab_embed = tab_embed_fixture(event.id)
      assert PageContents.get_tab_embed(tab_embed.id) == tab_embed
    end

    test "get_tab_embed/2 return teh tab_embed with given event_id and title", %{event: event} do
      tab_embed = tab_embed_fixture(event.id)
      assert PageContents.get_tab_embed(tab_embed.page_contents_event_id, tab_embed.title) == tab_embed
    end

    test "create_tab_embed/1 with valid data creates a tab_embed" do
      assert {:ok, %TabEmbed{} = tab_embed} = PageContents.create_tab_embed(@valid_attrs)
      assert tab_embed.title == "some title"
      assert tab_embed.url == "https://riseconf.com/tickets"
    end

    test "create_tab_embed/1 with invalid data returns error changeset (validate_required)" do
      expected_errors = [
        title: {"can't be blank", [validation: :required]},
        url: {"can't be blank", [validation: :required]},
      ]
      assert {:error, %Ecto.Changeset{} = changeset } = PageContents.create_tab_embed(@invalid_attrs)
      assert changeset.errors == expected_errors
    end


    test "create_tab_embed/1 with invalid data returns error changeset (validate_length max name title description)", %{event: event} do

      fake_title = Faker.Lorem.sentence(%Range{first: 21, last: 1000})
      invalid_title_lenght_attrs = %{
        title: fake_title, url: "https://riseconf.com/tickets", page_contents_event_id: event.id
      }
      expected_errors = [
        title: {"should be at most %{count} character(s)", [count: 20, validation: :length, max: 20]},
      ]
      assert {:error, %Ecto.Changeset{} = changeset} = PageContents.create_tab_embed(invalid_title_lenght_attrs)
      assert changeset.errors == expected_errors
    end

    test "update_tab_embed/2 with valid data updates the tab_embed", %{event: event} do
      tab_embed = tab_embed_fixture(event.id)
      assert {:ok, tab_embed} = PageContents.update_tab_embed(tab_embed, @update_attrs)
      assert %TabEmbed{} = tab_embed

      assert tab_embed.title == "some updated title"
      assert tab_embed.url == "https://riseconf.com/faq"
    end

    test "update_tab_embed/2 with invalid data returns error changeset  (validate_required)", %{event: event} do
      tab_embed = tab_embed_fixture(event.id)
      expected_errors = [
        title: {"can't be blank", [validation: :required]},
        url: {"can't be blank", [validation: :required]},
      ]
      assert {:error, %Ecto.Changeset{} = changeset } = PageContents.update_tab_embed(tab_embed, @invalid_attrs)
      assert changeset.errors == expected_errors

      assert tab_embed == PageContents.get_tab_embed!(tab_embed.id)
    end

    test "update_tab_embed/2 with invalid data returns error changeset  (validate_length name)", %{event: event} do
      tab_embed = tab_embed_fixture(event.id)
      invalid_title_lenght_attrs = %{title: "so"}

      expected_errors = [
        title: {"should be at least %{count} character(s)", [count: 3, validation: :length, min: 3]}
      ]
      assert {:error, %Ecto.Changeset{} = changeset} = PageContents.update_tab_embed(tab_embed, invalid_title_lenght_attrs)
      assert changeset.errors == expected_errors

      assert tab_embed == PageContents.get_tab_embed!(tab_embed.id)
    end

    test "delete_tab_embed/1 deletes the attendee", %{event: event}  do
      tab_embed = tab_embed_fixture(event.id)
      assert {:ok, %TabEmbed{}} = PageContents.delete_tab_embed(tab_embed)
      assert_raise Ecto.NoResultsError, fn -> PageContents.get_tab_embed!(tab_embed.id) end
    end

    test "change_tab_embed/1 returns a attendee changeset", %{event: event} do
      tab_embed = tab_embed_fixture(event.id)
      assert %Ecto.Changeset{} = PageContents.change_tab_embed(tab_embed)
    end

  end


  describe "attendee" do

    alias EventPage.PageContents.Event
    alias EventPage.PageContents.Attendee

    @valid_attrs %{
      description: "some description", name: "some name", title: "some title", page_contents_event_id: 1
    }
    @update_attrs %{
      description: "some updated description", name: "some updated name", title: "some updated title"
    }
    @invalid_attrs %{description: nil, name: nil, title: nil}

    setup do
      event = event_fixture()
      {:ok, event: event}
    end

    def attendee_fixture(event_id) do
      attrs = @valid_attrs |> Map.put(:page_contents_event_id, event_id)
      {:ok, attendee} = PageContents.create_attendee(attrs)
      attendee
    end

    test "list_attendees/1 returns all attendees given a event id", %{event: event} do
      attendee = attendee_fixture(event.id)
      assert PageContents.list_attendees(attendee.page_contents_event_id) == [attendee]
    end

    test "get_attendee/1 returns the attendee with given id", %{event: event} do
      attendee = attendee_fixture(event.id)
      assert PageContents.get_attendee(attendee.id) == attendee
    end

    test "get_attendee/1 returns nil with given id" do
      attendee_id = :rand.uniform(round(1.0e5))
      assert PageContents.get_attendee(attendee_id) == nil
    end

    test "get_attendee!/1 returns the attendee with given id", %{event: event} do
      attendee = attendee_fixture(event.id)
      assert PageContents.get_attendee!(attendee.id) == attendee
    end

    test "create_attendee/1 with valid data creates a attendee" do
      assert {:ok, %Attendee{} = attendee} = PageContents.create_attendee(@valid_attrs)
      assert attendee.description == "some description"
      assert attendee.name == "some name"
      assert attendee.title == "some title"
    end

    test "create_attendee/1 with invalid data returns error changeset (validate_required)" do
      expected_errors = [
        name: {"can't be blank", [validation: :required]},
        title: {"can't be blank", [validation: :required]},
        description: {"can't be blank", [validation: :required]}
      ]
      assert {:error, %Ecto.Changeset{} = changeset } = PageContents.create_attendee(@invalid_attrs)
      assert changeset.errors == expected_errors
    end

    test "create_attendee/1 with invalid data returns error changeset (validate_length min name title description)", %{event: event} do
      invalid_name_lenght_attrs = %{name: "so", description: "s", title: "s", page_contents_event_id: event.id}
      expected_errors = [
        title: {"should be at least %{count} character(s)", [count: 3, validation: :length, min: 3]},
        name: {"should be at least %{count} character(s)", [count: 3, validation: :length, min: 3]},
      ]
      assert {:error, %Ecto.Changeset{} = changeset} = PageContents.create_attendee(invalid_name_lenght_attrs)
      assert changeset.errors == expected_errors
    end

    test "create_attendee/1 with invalid data returns error changeset (validate_length max name title description)", %{event: event} do
      fake_name = Faker.Lorem.sentence(%Range{first: 101, last: 1000})
      fake_title = Faker.Lorem.sentence(%Range{first: 101, last: 1000})
      fake_description = Faker.Lorem.sentence(%Range{first: 1001, last: 5000})
      invalid_name_lenght_attrs = %{
        name: fake_name, description: fake_description, title: fake_title, page_contents_event_id: event.id
      }
      expected_errors = [
        title: {"should be at most %{count} character(s)", [count: 100, validation: :length, max: 100]},
        name: {"should be at most %{count} character(s)", [count: 100, validation: :length, max: 100]}
      ]
      assert {:error, %Ecto.Changeset{} = changeset} = PageContents.create_attendee(invalid_name_lenght_attrs)
      assert changeset.errors == expected_errors
    end

    test "update_attendee/2 with valid data updates the attendee", %{event: event} do
      attendee = attendee_fixture(event.id)
      assert {:ok, attendee} = PageContents.update_attendee(attendee, @update_attrs)
      assert %Attendee{} = attendee
      assert attendee.description == "some updated description"
      assert attendee.name == "some updated name"
    end

    test "update_attendee/2 with invalid data returns error changeset  (validate_required)", %{event: event} do
      attendee = attendee_fixture(event.id)
      expected_errors = [
        name: {"can't be blank", [validation: :required]},
        title: {"can't be blank", [validation: :required]},
        description: {"can't be blank", [validation: :required]}
      ]
      assert {:error, %Ecto.Changeset{} = changeset } = PageContents.update_attendee(attendee, @invalid_attrs)
      assert changeset.errors == expected_errors

      assert attendee == PageContents.get_attendee!(attendee.id)
    end

    test "update_attendee/2 with invalid data returns error changeset  (validate_length name)", %{event: event} do
      invalid_name_lenght_attrs = %{name: "so", description: "some description", banner: @fixture_banner_upload1}
      attendee = attendee_fixture(event.id)
      expected_errors = [
        name: {"should be at least %{count} character(s)", [count: 3, validation: :length, min: 3]}
      ]
      assert {:error, %Ecto.Changeset{} = changeset} = PageContents.update_attendee(attendee, invalid_name_lenght_attrs)
      assert changeset.errors == expected_errors

      assert attendee == PageContents.get_attendee!(attendee.id)
    end

    test "delete_attendee/1 deletes the attendee", %{event: event} do
      attendee = attendee_fixture(event.id)
      assert {:ok, %Attendee{}} = PageContents.delete_attendee(attendee)
      assert_raise Ecto.NoResultsError, fn -> PageContents.get_event!(attendee.id) end
    end

    test "change_attendee/1 returns a attendee changeset", %{event: event}do
      attendee = attendee_fixture(event.id)
      assert %Ecto.Changeset{} = PageContents.change_attendee(attendee)
    end
  end


end
