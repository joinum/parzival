defmodule Parzival.CompaniesTest do
  use Parzival.DataCase

  alias Parzival.Companies

  describe "offers" do
    alias Parzival.Companies.Offer

    import Parzival.CompaniesFixtures

    @invalid_attrs %{maximum_salary: nil, minimum_salary: nil, title: nil, type: nil}

    test "list_offers/0 returns all offers" do
      offer = offer_fixture()
      assert Companies.list_offers() == [offer]
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
        type: "some type"
      }

      assert {:ok, %Offer{} = offer} = Companies.create_offer(valid_attrs)
      assert offer.maximum_salary == 42
      assert offer.minimum_salary == 42
      assert offer.title == "some title"
      assert offer.type == "some type"
    end

    test "create_offer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_offer(@invalid_attrs)
    end

    test "update_offer/2 with valid data updates the offer" do
      offer = offer_fixture()

      update_attrs = %{
        maximum_salary: 43,
        minimum_salary: 43,
        title: "some updated title",
        type: "some updated type"
      }

      assert {:ok, %Offer{} = offer} = Companies.update_offer(offer, update_attrs)
      assert offer.maximum_salary == 43
      assert offer.minimum_salary == 43
      assert offer.title == "some updated title"
      assert offer.type == "some updated type"
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
      assert Companies.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{description: "some description", name: "some name"}

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
      assert Companies.list_offer_types() == [offer_type]
    end

    test "get_offer_type!/1 returns the offer_type with given id" do
      offer_type = offer_type_fixture()
      assert Companies.get_offer_type!(offer_type.id) == offer_type
    end

    test "create_offer_type/1 with valid data creates a offer_type" do
      valid_attrs = %{color: "some color", name: "some name"}

      assert {:ok, %OfferType{} = offer_type} = Companies.create_offer_type(valid_attrs)
      assert offer_type.color == "some color"
      assert offer_type.name == "some name"
    end

    test "create_offer_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_offer_type(@invalid_attrs)
    end

    test "update_offer_type/2 with valid data updates the offer_type" do
      offer_type = offer_type_fixture()
      update_attrs = %{color: "some updated color", name: "some updated name"}

      assert {:ok, %OfferType{} = offer_type} =
               Companies.update_offer_type(offer_type, update_attrs)

      assert offer_type.color == "some updated color"
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
      assert Companies.list_offer_times() == [offer_time]
    end

    test "get_offer_time!/1 returns the offer_time with given id" do
      offer_time = offer_time_fixture()
      assert Companies.get_offer_time!(offer_time.id) == offer_time
    end

    test "create_offer_time/1 with valid data creates a offer_time" do
      valid_attrs = %{color: "some color", name: "some name"}

      assert {:ok, %OfferTime{} = offer_time} = Companies.create_offer_time(valid_attrs)
      assert offer_time.color == "some color"
      assert offer_time.name == "some name"
    end

    test "create_offer_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_offer_time(@invalid_attrs)
    end

    test "update_offer_time/2 with valid data updates the offer_time" do
      offer_time = offer_time_fixture()
      update_attrs = %{color: "some updated color", name: "some updated name"}

      assert {:ok, %OfferTime{} = offer_time} =
               Companies.update_offer_time(offer_time, update_attrs)

      assert offer_time.color == "some updated color"
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
      assert Companies.list_applications() == [application]
    end

    test "get_application!/1 returns the application with given id" do
      application = application_fixture()
      assert Companies.get_application!(application.id) == application
    end

    test "create_application/1 with valid data creates a application" do
      valid_attrs = %{}

      assert {:ok, %Application{} = application} = Companies.create_application(valid_attrs)
    end

    test "create_application/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_application(@invalid_attrs)
    end

    test "update_application/2 with valid data updates the application" do
      application = application_fixture()
      update_attrs = %{}

      assert {:ok, %Application{} = application} =
               Companies.update_application(application, update_attrs)
    end

    test "update_application/2 with invalid data returns error changeset" do
      application = application_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Companies.update_application(application, @invalid_attrs)

      assert application == Companies.get_application!(application.id)
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
      assert Companies.list_levels() == [level]
    end

    test "get_level!/1 returns the level with given id" do
      level = level_fixture()
      assert Companies.get_level!(level.id) == level
    end

    test "create_level/1 with valid data creates a level" do
      valid_attrs = %{color: "some color", name: "some name"}

      assert {:ok, %Level{} = level} = Companies.create_level(valid_attrs)
      assert level.color == "some color"
      assert level.name == "some name"
    end

    test "create_level/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_level(@invalid_attrs)
    end

    test "update_level/2 with valid data updates the level" do
      level = level_fixture()
      update_attrs = %{color: "some updated color", name: "some updated name"}

      assert {:ok, %Level{} = level} = Companies.update_level(level, update_attrs)
      assert level.color == "some updated color"
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
end
