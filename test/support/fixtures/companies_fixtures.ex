defmodule Parzival.CompaniesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Parzival.Companies` context.
  """

  @doc """
  Generate a offer.
  """
  def offer_fixture(attrs \\ %{}) do
    {:ok, offer} =
      attrs
      |> Enum.into(%{
        maximum_salary: 42,
        minimum_salary: 42,
        title: "some title",
        location: "some location",
        description: "some description",
        applied: 42,
        company_id: company_fixture().id,
        offer_type_id: offer_type_fixture().id,
        offer_time_id: offer_time_fixture().id,
        work_model: "remote"
      })
      |> Parzival.Companies.create_offer()

    offer
  end

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        level_id: level_fixture().id
      })
      |> Parzival.Companies.create_company()

    company
  end

  @doc """
  Generate a offer_type.
  """
  def offer_type_fixture(attrs \\ %{}) do
    {:ok, offer_type} =
      attrs
      |> Enum.into(%{
        color: "gray",
        name: "some name"
      })
      |> Parzival.Companies.create_offer_type()

    offer_type
  end

  @doc """
  Generate a offer_time.
  """
  def offer_time_fixture(attrs \\ %{}) do
    {:ok, offer_time} =
      attrs
      |> Enum.into(%{
        color: "gray",
        name: "some name"
      })
      |> Parzival.Companies.create_offer_time()

    offer_time
  end

  @doc """
  Generate a application.
  """
  def application_fixture(attrs \\ %{}) do
    {:ok, application} =
      attrs
      |> Enum.into(%{
        user_id: Parzival.AccountsFixtures.user_fixture().id,
        offer_id: offer_fixture().id
      })
      |> Parzival.Companies.create_application()

    application
  end

  @doc """
  Generate a level.
  """
  def level_fixture(attrs \\ %{}) do
    {:ok, level} =
      attrs
      |> Enum.into(%{
        color: "gray",
        name: "some name"
      })
      |> Parzival.Companies.create_level()

    level
  end

  @doc """
  Generate a connection.
  """
  def connection_fixture do
    {:ok, connection} =
      Parzival.Companies.create_connection(
        company_fixture(),
        Parzival.AccountsFixtures.user_fixture()
      )

    connection
  end
end
