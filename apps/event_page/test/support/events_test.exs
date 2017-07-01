defmodule EventPage.EventsTest do
  use EventPage.DataCase


  alias EventPage.Events

  describe "event_details" do
    alias EventPage.Events.EventDetail


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

    def event_detail_fixture(attrs \\ %{}) do
        attrs = attrs |> Enum.into(@valid_attrs)
        {:ok, event_detail} = Events.create_event_detail(attrs)
        event_detail
    end

    test "list_event_details/0 returns all event_details" do
      event_detail = event_detail_fixture()
      assert Events.list_event_details() == [event_detail]
    end

    test "get_event_detail/1 returns the event_detail with given id" do
      event_detail = event_detail_fixture()
      assert Events.get_event_detail(event_detail.id) == event_detail
    end

    test "get_event_detail/1 returns nil with given id" do
      event_detail_id = :rand.uniform(round(1.0e5))
      assert Events.get_event_detail(event_detail_id) == nil
    end

    test "get_event_detail!/1 returns the event_detail with given id" do
      event_detail = event_detail_fixture()
      assert Events.get_event_detail!(event_detail.id) == event_detail
    end

    test "create_event_detail/1 with valid data creates a event_detail" do
      assert {:ok, %EventDetail{} = event_detail} = Events.create_event_detail(@valid_attrs)
      assert event_detail.description == "some description"
      assert event_detail.name == "some name"
    end

    test "create_event_detail/1 with invalid data returns error changeset (validate_required)" do
      expected_errors = [
        name: {"can't be blank", [validation: :required]},
        description: {"can't be blank", [validation: :required]},
        banner: {"can't be blank", [validation: :required]}
      ]
      assert {:error, %Ecto.Changeset{} = changeset } = Events.create_event_detail(@invalid_attrs)
      assert changeset.errors == expected_errors
    end

    test "create_event_detail/1 with invalid data returns error changeset (validate_length min name description)" do
      invalid_name_lenght_attrs = %{name: "so", description: "s", banner: @fixture_banner_upload1}
      expected_errors = [
        description: {"should be at least %{count} character(s)", [count: 3, validation: :length, min: 3]},
        name: {"should be at least %{count} character(s)", [count: 3, validation: :length, min: 3]},
      ]
      assert {:error, %Ecto.Changeset{} = changeset} = Events.create_event_detail(invalid_name_lenght_attrs)
      assert changeset.errors == expected_errors
    end

    test "create_event_detail/1 with invalid data returns error changeset (validate_length max name description)" do
      fake_name = Faker.Lorem.sentence(%Range{first: 101, last: 1000})
      fake_description = Faker.Lorem.sentence(%Range{first: 501, last: 5000})
      invalid_name_lenght_attrs = %{name: fake_name, description: fake_description, banner: @fixture_banner_upload1}
      expected_errors = [
        description: {"should be at most %{count} character(s)", [count: 500, validation: :length, max: 500]},
        name: {"should be at most %{count} character(s)", [count: 100, validation: :length, max: 100]},
      ]
      assert {:error, %Ecto.Changeset{} = changeset} = Events.create_event_detail(invalid_name_lenght_attrs)
      assert changeset.errors == expected_errors
    end

    test "update_event_detail/2 with valid data updates the event_detail" do
      event_detail = event_detail_fixture()
      assert {:ok, event_detail} = Events.update_event_detail(event_detail, @update_attrs)
      assert %EventDetail{} = event_detail
      assert event_detail.description == "some updated description"
      assert event_detail.name == "some updated name"
    end

    test "update_event_detail/2 with invalid data returns error changeset  (validate_required)" do
      event_detail = event_detail_fixture()
      expected_errors = [
        name: {"can't be blank", [validation: :required]},
        description: {"can't be blank", [validation: :required]}
      ]
      assert {:error, %Ecto.Changeset{} = changeset } = Events.update_event_detail(event_detail, @invalid_attrs)
      assert changeset.errors == expected_errors

      assert event_detail == Events.get_event_detail!(event_detail.id)
    end

    test "update_event_detail/2 with invalid data returns error changeset  (validate_length name)" do
      invalid_name_lenght_attrs = %{name: "so", description: "some description", banner: @fixture_banner_upload1}
      event_detail = event_detail_fixture()
      expected_errors = [
        name: {"should be at least %{count} character(s)", [count: 3, validation: :length, min: 3]}
      ]
      assert {:error, %Ecto.Changeset{} = changeset} = Events.create_event_detail(invalid_name_lenght_attrs)
      assert changeset.errors == expected_errors

      assert event_detail == Events.get_event_detail!(event_detail.id)
    end

    test "delete_event_detail/1 deletes the event_detail" do
      event_detail = event_detail_fixture()
      assert {:ok, %EventDetail{}} = Events.delete_event_detail(event_detail)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event_detail!(event_detail.id) end
    end

    test "change_event_detail/1 returns a event_detail changeset" do
      event_detail = event_detail_fixture()
      assert %Ecto.Changeset{} = Events.change_event_detail(event_detail)
    end
  end
end
