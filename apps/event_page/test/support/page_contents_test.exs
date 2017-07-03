defmodule EventPage.PageContentsTest do
  use EventPage.DataCase


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
        description: {"can't be blank", [validation: :required]},
        banner: {"can't be blank", [validation: :required]}
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
end
