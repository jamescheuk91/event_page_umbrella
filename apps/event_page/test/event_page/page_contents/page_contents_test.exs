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

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = PageContents.create_event(@valid_attrs)
      assert event.description == "some description"
      assert event.name == "some name"
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
      fake_description = Faker.Lorem.sentence(%Range{first: 501, last: 5000})
      invalid_name_lenght_attrs = %{name: fake_name, description: fake_description, banner: @fixture_banner_upload1}
      expected_errors = [
        description: {"should be at most %{count} character(s)", [count: 500, validation: :length, max: 500]},
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

    test "update_event/2 with valid attendees list updates the event" do
      event = event_fixture()
      attendees_list = [%{name: "attendee1 name", title: "attendee1 title", description: "attendee1 description"}]
      update_attrs = @update_attrs |> Map.put(:attendees, attendees_list)
      assert {:ok, event} = PageContents.update_event(event, update_attrs)
      assert %Event{} = event
      assert event.description == "some updated description"
      assert event.name == "some updated name"
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


  describe "attendee" do
    alias EventPage.PageContents.Event
    alias EventPage.PageContents.Attendee

    # @fixture_banner_upload1 %Plug.Upload{path: "test/fixtures/fixture_banner1.jpeg", filename: "fixture_banner1.jpeg"}
    # @fixture_banner_upload2 %Plug.Upload{path: "test/fixtures/fixture_banner2.jpeg", filename: "fixture_banner2.jpeg"}

    @valid_attrs %{
      description: "some description", name: "some name", title: "some title", page_contents_event_id: 1
    }
    @update_attrs %{
      description: "some updated description", name: "some updated name", title: "some updated title"
    }
    @invalid_attrs %{description: nil, name: nil, title: nil}

    def attendee_fixture(attrs \\ %{}) do
      event = event_fixture()
      attrs = attrs |> Enum.into(@valid_attrs) |> Map.put(:page_contents_event_id, event.id)
      {:ok, attendee} = PageContents.create_attendee(attrs)
      attendee
    end

    test "list_attendees/1 returns all attendees" do
      attendee = attendee_fixture()
      assert PageContents.list_attendees(attendee.page_contents_event_id) == [attendee]
    end

    test "get_attendee/1 returns the attendee with given id" do
      attendee = attendee_fixture()
      assert PageContents.get_attendee(attendee.id) == attendee
    end

    test "get_attendee/1 returns nil with given id" do
      attendee_id = :rand.uniform(round(1.0e5))
      assert PageContents.get_attendee(attendee_id) == nil
    end

    test "get_attendee!/1 returns the attendee with given id" do
      attendee = attendee_fixture()
      assert PageContents.get_attendee!(attendee.id) == attendee
    end

    test "create_attendee/2 with valid data creates a attendee" do
      assert {:ok, %Attendee{} = attendee} = PageContents.create_attendee(@valid_attrs)
      assert attendee.description == "some description"
      assert attendee.name == "some name"
      assert attendee.title == "some title"
    end

    test "create_attendee/2 with invalid data returns error changeset (validate_required)" do
      expected_errors = [
        name: {"can't be blank", [validation: :required]},
        title: {"can't be blank", [validation: :required]},
        description: {"can't be blank", [validation: :required]}
      ]
      assert {:error, %Ecto.Changeset{} = changeset } = PageContents.create_attendee(@invalid_attrs)
      assert changeset.errors == expected_errors
    end

    test "create_attendee/2 with invalid data returns error changeset (validate_length min name title description)" do
      event = event_fixture()
      invalid_name_lenght_attrs = %{name: "so", description: "s", title: "s", page_contents_event_id: event.id}
      expected_errors = [
        description: {"should be at least %{count} character(s)", [count: 3, validation: :length, min: 3]},
        title: {"should be at least %{count} character(s)", [count: 3, validation: :length, min: 3]},
        name: {"should be at least %{count} character(s)", [count: 3, validation: :length, min: 3]},
      ]
      assert {:error, %Ecto.Changeset{} = changeset} = PageContents.create_attendee(invalid_name_lenght_attrs)
      assert changeset.errors == expected_errors
    end

    test "create_attendee/1 with invalid data returns error changeset (validate_length max name title description)" do
      event = event_fixture()
      fake_name = Faker.Lorem.sentence(%Range{first: 101, last: 1000})
      fake_title = Faker.Lorem.sentence(%Range{first: 101, last: 1000})
      fake_description = Faker.Lorem.sentence(%Range{first: 501, last: 5000})
      invalid_name_lenght_attrs = %{name: fake_name, description: fake_description, title: fake_title, page_contents_event_id: event.id}
      expected_errors = [
        description: {"should be at most %{count} character(s)", [count: 500, validation: :length, max: 500]},
        title: {"should be at most %{count} character(s)", [count: 100, validation: :length, max: 100]},
        name: {"should be at most %{count} character(s)", [count: 100, validation: :length, max: 100]}
      ]
      assert {:error, %Ecto.Changeset{} = changeset} = PageContents.create_attendee(invalid_name_lenght_attrs)
      assert changeset.errors == expected_errors
    end

    test "update_attendee/2 with valid data updates the attendee" do
      attendee = attendee_fixture()
      assert {:ok, attendee} = PageContents.update_attendee(attendee, @update_attrs)
      assert %Attendee{} = attendee
      assert attendee.description == "some updated description"
      assert attendee.name == "some updated name"
    end

    test "update_attendee/2 with invalid data returns error changeset  (validate_required)" do
      attendee = attendee_fixture()
      expected_errors = [
        name: {"can't be blank", [validation: :required]},
        title: {"can't be blank", [validation: :required]},
        description: {"can't be blank", [validation: :required]}
      ]
      assert {:error, %Ecto.Changeset{} = changeset } = PageContents.update_attendee(attendee, @invalid_attrs)
      assert changeset.errors == expected_errors

      assert attendee == PageContents.get_attendee!(attendee.id)
    end

    test "update_attendee/2 with invalid data returns error changeset  (validate_length name)" do
      invalid_name_lenght_attrs = %{name: "so", description: "some description", banner: @fixture_banner_upload1}
      attendee = attendee_fixture()
      expected_errors = [
        name: {"should be at least %{count} character(s)", [count: 3, validation: :length, min: 3]}
      ]
      assert {:error, %Ecto.Changeset{} = changeset} = PageContents.update_attendee(attendee, invalid_name_lenght_attrs)
      assert changeset.errors == expected_errors

      assert attendee == PageContents.get_attendee!(attendee.id)
    end

    test "delete_attendee/1 deletes the attendee" do
      attendee = attendee_fixture()
      assert {:ok, %Attendee{}} = PageContents.delete_attendee(attendee)
      assert_raise Ecto.NoResultsError, fn -> PageContents.get_event!(attendee.id) end
    end

    test "change_attendee/1 returns a attendee changeset" do
      attendee = attendee_fixture()
      assert %Ecto.Changeset{} = PageContents.change_attendee(attendee)
    end
  end


end
