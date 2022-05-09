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
end
