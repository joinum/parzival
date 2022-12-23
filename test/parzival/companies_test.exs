defmodule Parzival.CompaniesTest do
  use Parzival.DataCase

  alias Parzival.Companies

  describe "offers" do
    alias Parzival.Companies.Offer

    import Parzival.CompaniesFixtures

    @invalid_attrs %{maximum_salary: nil, minimum_salary: nil, title: nil, type: nil}

    test "list_offers/0 returns all offers" do
      offer = offer_fixture()

      assert Companies.list_offers() ==
               {:ok,
                {[offer],
                 %Flop.Meta{
                   current_offset: 0,
                   current_page: 1,
                   end_cursor: nil,
                   errors: [],
                   flop: %Flop{
                     after: nil,
                     before: nil,
                     filters: [],
                     first: nil,
                     last: nil,
                     limit: 9,
                     offset: nil,
                     order_by: [:minimum_salary, :maximum_salary],
                     order_directions: [:desc, :desc],
                     page: nil,
                     page_size: nil
                   },
                   has_next_page?: false,
                   has_previous_page?: false,
                   next_offset: nil,
                   next_page: nil,
                   page_size: 9,
                   params: %{},
                   previous_offset: nil,
                   previous_page: nil,
                   schema: Parzival.Companies.Offer,
                   start_cursor: nil,
                   total_count: 1,
                   total_pages: 1
                 }}}
    end

    test "get_offer!/1 returns the offer with given id" do
      offer = offer_fixture()
      assert Companies.get_offer!(offer.id) == offer
    end

    test "create_offer/1 with valid data creates a offer" do
      valid_attrs = %{
        maximum_salary: 42,
        minimum_salary: 42,
        title: "some title",
        location: "somewhere over the rainbow",
        description: "i like you",
        offer_type_id: offer_type_fixture().id,
        offer_time_id: offer_time_fixture().id,
        company_id: company_fixture().id
      }

      assert {:ok, %Offer{} = offer} = Companies.create_offer(valid_attrs)
      assert offer.maximum_salary == 42
      assert offer.minimum_salary == 42
      assert offer.title == "some title"
      assert offer.location == "somewhere over the rainbow"
      assert offer.description == "i like you"
    end

    test "create_offer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_offer(@invalid_attrs)
    end

    test "update_offer/2 with valid data updates the offer" do
      offer = offer_fixture()

      update_attrs = %{
        maximum_salary: 43,
        minimum_salary: 43,
        title: "some updated title"
      }

      assert {:ok, %Offer{} = offer} = Companies.update_offer(offer, update_attrs)
      assert offer.maximum_salary == 43
      assert offer.minimum_salary == 43
      assert offer.title == "some updated title"
    end

    test "update_offer/2 with invalid data returns error changeset" do
      offer = offer_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_offer(offer, @invalid_attrs)
      assert offer == Companies.get_offer!(offer.id)
    end

    test "delete_offer/1 deletes the offer" do
      offer = offer_fixture()
      assert {:ok, %Offer{}} = Companies.delete_offer(offer)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_offer!(offer.id) end
    end

    test "change_offer/1 returns a offer changeset" do
      offer = offer_fixture()
      assert %Ecto.Changeset{} = Companies.change_offer(offer)
    end
  end

  describe "companies" do
    alias Parzival.Companies.Company

    import Parzival.CompaniesFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_companies/0 returns all companies" do
      company = company_fixture()

      assert Companies.list_companies() ==
               {:ok,
                {[company],
                 %Flop.Meta{
                   current_offset: 0,
                   current_page: 1,
                   end_cursor: nil,
                   errors: [],
                   flop: %Flop{
                     after: nil,
                     before: nil,
                     filters: [],
                     first: nil,
                     last: nil,
                     limit: 9,
                     offset: nil,
                     order_by: [:name],
                     order_directions: [:asc],
                     page: nil,
                     page_size: nil
                   },
                   has_next_page?: false,
                   has_previous_page?: false,
                   next_offset: nil,
                   next_page: nil,
                   page_size: 9,
                   params: %{},
                   previous_offset: nil,
                   previous_page: nil,
                   schema: Parzival.Companies.Company,
                   start_cursor: nil,
                   total_count: 1,
                   total_pages: 1
                 }}}
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{
        description: "some description",
        name: "some name",
        level_id: level_fixture().id
      }

      assert {:ok, %Company{} = company} = Companies.create_company(valid_attrs)
      assert company.description == "some description"
      assert company.name == "some name"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Company{} = company} = Companies.update_company(company, update_attrs)
      assert company.description == "some updated description"
      assert company.name == "some updated name"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end
  end

  describe "offer_types" do
    alias Parzival.Companies.OfferType

    import Parzival.CompaniesFixtures

    @invalid_attrs %{color: nil, name: nil}

    test "list_offer_types/0 returns all offer_types" do
      offer_type = offer_type_fixture()

      assert Companies.list_offer_types() ==
               {:ok,
                {[offer_type],
                 %Flop.Meta{
                   current_offset: 0,
                   current_page: 1,
                   end_cursor: nil,
                   errors: [],
                   flop: %Flop{
                     after: nil,
                     before: nil,
                     filters: [],
                     first: nil,
                     last: nil,
                     limit: 9,
                     offset: nil,
                     order_by: [:name],
                     order_directions: [:asc],
                     page: nil,
                     page_size: nil
                   },
                   has_next_page?: false,
                   has_previous_page?: false,
                   next_offset: nil,
                   next_page: nil,
                   page_size: 9,
                   params: %{},
                   previous_offset: nil,
                   previous_page: nil,
                   schema: Parzival.Companies.OfferType,
                   start_cursor: nil,
                   total_count: 1,
                   total_pages: 1
                 }}}
    end

    test "get_offer_type!/1 returns the offer_type with given id" do
      offer_type = offer_type_fixture()
      assert Companies.get_offer_type!(offer_type.id) == offer_type
    end

    test "create_offer_type/1 with valid data creates a offer_type" do
      valid_attrs = %{color: "red", name: "some name"}

      assert {:ok, %OfferType{} = offer_type} = Companies.create_offer_type(valid_attrs)
      assert offer_type.color == :red
      assert offer_type.name == "some name"
    end

    test "create_offer_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_offer_type(@invalid_attrs)
    end

    test "update_offer_type/2 with valid data updates the offer_type" do
      offer_type = offer_type_fixture()
      update_attrs = %{color: "green", name: "some updated name"}

      assert {:ok, %OfferType{} = offer_type} =
               Companies.update_offer_type(offer_type, update_attrs)

      assert offer_type.color == :green
      assert offer_type.name == "some updated name"
    end

    test "update_offer_type/2 with invalid data returns error changeset" do
      offer_type = offer_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_offer_type(offer_type, @invalid_attrs)
      assert offer_type == Companies.get_offer_type!(offer_type.id)
    end

    test "delete_offer_type/1 deletes the offer_type" do
      offer_type = offer_type_fixture()
      assert {:ok, %OfferType{}} = Companies.delete_offer_type(offer_type)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_offer_type!(offer_type.id) end
    end

    test "change_offer_type/1 returns a offer_type changeset" do
      offer_type = offer_type_fixture()
      assert %Ecto.Changeset{} = Companies.change_offer_type(offer_type)
    end
  end

  describe "offer_times" do
    alias Parzival.Companies.OfferTime

    import Parzival.CompaniesFixtures

    @invalid_attrs %{color: nil, name: nil}

    test "list_offer_times/0 returns all offer_times" do
      offer_time = offer_time_fixture()

      assert Companies.list_offer_times() ==
               {:ok,
                {[offer_time],
                 %Flop.Meta{
                   current_offset: 0,
                   current_page: 1,
                   end_cursor: nil,
                   errors: [],
                   flop: %Flop{
                     after: nil,
                     before: nil,
                     filters: [],
                     first: nil,
                     last: nil,
                     limit: 9,
                     offset: nil,
                     order_by: [:name],
                     order_directions: [:asc],
                     page: nil,
                     page_size: nil
                   },
                   has_next_page?: false,
                   has_previous_page?: false,
                   next_offset: nil,
                   next_page: nil,
                   page_size: 9,
                   params: %{},
                   previous_offset: nil,
                   previous_page: nil,
                   schema: Parzival.Companies.OfferTime,
                   start_cursor: nil,
                   total_count: 1,
                   total_pages: 1
                 }}}
    end

    test "get_offer_time!/1 returns the offer_time with given id" do
      offer_time = offer_time_fixture()
      assert Companies.get_offer_time!(offer_time.id) == offer_time
    end

    test "create_offer_time/1 with valid data creates a offer_time" do
      valid_attrs = %{color: "red", name: "some name"}

      assert {:ok, %OfferTime{} = offer_time} = Companies.create_offer_time(valid_attrs)
      assert offer_time.color == :red
      assert offer_time.name == "some name"
    end

    test "create_offer_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_offer_time(@invalid_attrs)
    end

    test "update_offer_time/2 with valid data updates the offer_time" do
      offer_time = offer_time_fixture()
      update_attrs = %{color: "orange", name: "some updated name"}

      assert {:ok, %OfferTime{} = offer_time} =
               Companies.update_offer_time(offer_time, update_attrs)

      assert offer_time.color == :orange
      assert offer_time.name == "some updated name"
    end

    test "update_offer_time/2 with invalid data returns error changeset" do
      offer_time = offer_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_offer_time(offer_time, @invalid_attrs)
      assert offer_time == Companies.get_offer_time!(offer_time.id)
    end

    test "delete_offer_time/1 deletes the offer_time" do
      offer_time = offer_time_fixture()
      assert {:ok, %OfferTime{}} = Companies.delete_offer_time(offer_time)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_offer_time!(offer_time.id) end
    end

    test "change_offer_time/1 returns a offer_time changeset" do
      offer_time = offer_time_fixture()
      assert %Ecto.Changeset{} = Companies.change_offer_time(offer_time)
    end
  end

  describe "applications" do
    alias Parzival.Companies.Application

    import Parzival.CompaniesFixtures

    @invalid_attrs %{}

    test "list_applications/0 returns all applications" do
      application = application_fixture()

      assert Companies.list_applications() ==
               {:ok,
                {[application],
                 %Flop.Meta{
                   current_offset: 0,
                   current_page: 1,
                   end_cursor: nil,
                   errors: [],
                   flop: %Flop{
                     after: nil,
                     before: nil,
                     filters: [],
                     first: nil,
                     last: nil,
                     limit: 9,
                     offset: nil,
                     order_by: [],
                     order_directions: [:asc],
                     page: nil,
                     page_size: nil
                   },
                   has_next_page?: false,
                   has_previous_page?: false,
                   next_offset: nil,
                   next_page: nil,
                   page_size: 9,
                   params: %{},
                   previous_offset: nil,
                   previous_page: nil,
                   schema: Parzival.Companies.Application,
                   start_cursor: nil,
                   total_count: 1,
                   total_pages: 1
                 }}}
    end

    test "get_application!/1 returns the application with given id" do
      application = application_fixture()
      assert Companies.get_application!(application.id) == application
    end

    test "create_application/1 with valid data creates a application" do
      valid_attrs = %{
        user_id: Parzival.AccountsFixtures.user_fixture().id,
        offer_id: offer_fixture().id
      }

      assert {:ok, %Application{} = application} = Companies.create_application(valid_attrs)
    end

    test "create_application/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_application(@invalid_attrs)
    end

    test "delete_application/1 deletes the application" do
      application = application_fixture()
      assert {:ok, %Application{}} = Companies.delete_application(application)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_application!(application.id) end
    end

    test "change_application/1 returns a application changeset" do
      application = application_fixture()
      assert %Ecto.Changeset{} = Companies.change_application(application)
    end
  end

  describe "levels" do
    alias Parzival.Companies.Level

    import Parzival.CompaniesFixtures

    @invalid_attrs %{color: nil, name: nil}

    test "list_levels/0 returns all levels" do
      level = level_fixture()

      assert Companies.list_levels() ==
               {:ok,
                {[level],
                 %Flop.Meta{
                   current_offset: 0,
                   current_page: 1,
                   end_cursor: nil,
                   errors: [],
                   flop: %Flop{
                     after: nil,
                     before: nil,
                     filters: [],
                     first: nil,
                     last: nil,
                     limit: 9,
                     offset: nil,
                     order_by: [:name],
                     order_directions: [:asc],
                     page: nil,
                     page_size: nil
                   },
                   has_next_page?: false,
                   has_previous_page?: false,
                   next_offset: nil,
                   next_page: nil,
                   page_size: 9,
                   params: %{},
                   previous_offset: nil,
                   previous_page: nil,
                   schema: Parzival.Companies.Level,
                   start_cursor: nil,
                   total_count: 1,
                   total_pages: 1
                 }}}
    end

    test "get_level!/1 returns the level with given id" do
      level = level_fixture()
      assert Companies.get_level!(level.id) == level
    end

    test "create_level/1 with valid data creates a level" do
      valid_attrs = %{color: "red", name: "some name"}

      assert {:ok, %Level{} = level} = Companies.create_level(valid_attrs)
      assert level.color == :red
      assert level.name == "some name"
    end

    test "create_level/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_level(@invalid_attrs)
    end

    test "update_level/2 with valid data updates the level" do
      level = level_fixture()
      update_attrs = %{color: "red", name: "some updated name"}

      assert {:ok, %Level{} = level} = Companies.update_level(level, update_attrs)
      assert level.color == :red
      assert level.name == "some updated name"
    end

    test "update_level/2 with invalid data returns error changeset" do
      level = level_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_level(level, @invalid_attrs)
      assert level == Companies.get_level!(level.id)
    end

    test "delete_level/1 deletes the level" do
      level = level_fixture()
      assert {:ok, %Level{}} = Companies.delete_level(level)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_level!(level.id) end
    end

    test "change_level/1 returns a level changeset" do
      level = level_fixture()
      assert %Ecto.Changeset{} = Companies.change_level(level)
    end
  end

  describe "connections" do
    alias Parzival.Companies.Connection

    import Parzival.CompaniesFixtures

    @invalid_attrs %{user_id: -1}

    test "list_connections/0 returns all connections" do
      connection = connection_fixture()

      assert Companies.list_connections() ==
               {:ok,
                {[connection],
                 %Flop.Meta{
                   current_offset: 0,
                   current_page: 1,
                   end_cursor: nil,
                   errors: [],
                   flop: %Flop{
                     after: nil,
                     before: nil,
                     filters: [],
                     first: nil,
                     last: nil,
                     limit: 9,
                     offset: nil,
                     order_by: [],
                     order_directions: [:asc],
                     page: nil,
                     page_size: nil
                   },
                   has_next_page?: false,
                   has_previous_page?: false,
                   next_offset: nil,
                   next_page: nil,
                   page_size: 9,
                   params: %{},
                   previous_offset: nil,
                   previous_page: nil,
                   schema: Parzival.Companies.Connection,
                   start_cursor: nil,
                   total_count: 1,
                   total_pages: 1
                 }}}
    end

    test "get_connection!/1 returns the connection with given id" do
      connection = connection_fixture()
      assert Companies.get_connection!(connection.id) == connection
    end

    test "create_connection/1 with valid data creates a connection" do
      valid_attrs = %{
        company_id: company_fixture().id,
        user_id: Parzival.AccountsFixtures.user_fixture().id
      }

      assert {:ok, %Connection{} = connection} = Companies.create_connection(valid_attrs)
    end

    test "create_connection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_connection(@invalid_attrs)
    end

    test "update_connection/2 with valid data updates the connection" do
      connection = connection_fixture()
      update_attrs = %{}

      assert {:ok, %Connection{} = connection} =
               Companies.update_connection(connection, update_attrs)
    end

    test "update_connection/2 with invalid data returns error changeset" do
      connection = connection_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_connection(connection, @invalid_attrs)
      assert connection == Companies.get_connection!(connection.id)
    end

    test "delete_connection/1 deletes the connection" do
      connection = connection_fixture()
      assert {:ok, %Connection{}} = Companies.delete_connection(connection)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_connection!(connection.id) end
    end

    test "change_connection/1 returns a connection changeset" do
      connection = connection_fixture()
      assert %Ecto.Changeset{} = Companies.change_connection(connection)
    end
  end
end
