defmodule Parzival.Companies do
  @moduledoc """
  The Companies context.
  """
  use Parzival.Context

  import Ecto.Query, warn: false
  alias Parzival.Repo

  alias Parzival.Accounts.User
  alias Parzival.Companies.Offer

  @doc """
  Returns the list of offers.

  ## Examples

      iex> list_offers()
      [%Offer{}, ...]

  """
  def list_offers(params \\ %{})

  def list_offers(opts) when is_list(opts) do
    Offer
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_offers(flop) do
    Flop.validate_and_run(Offer, flop, for: Offer)
  end

  def list_offers(%{} = flop, opts) when is_list(opts) do
    Offer
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Offer)
  end

  @doc """
  Gets a single offer.

  Raises `Ecto.NoResultsError` if the Offer does not exist.

  ## Examples

      iex> get_offer!(123)
      %Offer{}

      iex> get_offer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_offer!(id), do: Repo.get!(Offer, id)

  def get_offer!(id, opts) do
    Offer
    |> apply_filters(opts)
    |> Repo.get!(id)
  end

  @doc """
  Creates a offer.

  ## Examples

      iex> create_offer(%{field: value})
      {:ok, %Offer{}}

      iex> create_offer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_offer(attrs \\ %{}) do
    %Offer{}
    |> Offer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a offer.

  ## Examples

      iex> update_offer(offer, %{field: new_value})
      {:ok, %Offer{}}

      iex> update_offer(offer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_offer(%Offer{} = offer, attrs) do
    offer
    |> Offer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a offer.

  ## Examples

      iex> delete_offer(offer)
      {:ok, %Offer{}}

      iex> delete_offer(offer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_offer(%Offer{} = offer) do
    Repo.delete(offer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking offer changes.

  ## Examples

      iex> change_offer(offer)
      %Ecto.Changeset{data: %Offer{}}

  """
  def change_offer(%Offer{} = offer, attrs \\ %{}) do
    Offer.changeset(offer, attrs)
  end

  alias Parzival.Companies.Company

  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies()
      [%Company{}, ...]

  """
  def list_companies(params \\ %{})

  def list_companies(opts) when is_list(opts) do
    Company
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_companies(flop) do
    Flop.validate_and_run(Company, flop, for: Company)
  end

  def list_companies(%{} = flop, opts) when is_list(opts) do
    Company
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Company)
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id), do: Repo.get!(Company, id)

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  def change_company(%Company{} = company, attrs \\ %{}) do
    Company.changeset(company, attrs)
  end

  alias Parzival.Companies.OfferType

  @doc """
  Returns the list of offer_types.

  ## Examples

      iex> list_offer_types()
      [%OfferType{}, ...]

  """
  def list_offer_types(params \\ %{})

  def list_offer_types(opts) when is_list(opts) do
    OfferType
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_offer_types(flop) do
    Flop.validate_and_run(OfferType, flop, for: OfferType)
  end

  def list_offer_types(%{} = flop, opts) when is_list(opts) do
    OfferType
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: OfferType)
  end

  @doc """
  Gets a single offer_type.

  Raises `Ecto.NoResultsError` if the Offer type does not exist.

  ## Examples

      iex> get_offer_type!(123)
      %OfferType{}

      iex> get_offer_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_offer_type!(id), do: Repo.get!(OfferType, id)

  @doc """
  Creates a offer_type.

  ## Examples

      iex> create_offer_type(%{field: value})
      {:ok, %OfferType{}}

      iex> create_offer_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_offer_type(attrs \\ %{}) do
    %OfferType{}
    |> OfferType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a offer_type.

  ## Examples

      iex> update_offer_type(offer_type, %{field: new_value})
      {:ok, %OfferType{}}

      iex> update_offer_type(offer_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_offer_type(%OfferType{} = offer_type, attrs) do
    offer_type
    |> OfferType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a offer_type.

  ## Examples

      iex> delete_offer_type(offer_type)
      {:ok, %OfferType{}}

      iex> delete_offer_type(offer_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_offer_type(%OfferType{} = offer_type) do
    Repo.delete(offer_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking offer_type changes.

  ## Examples

      iex> change_offer_type(offer_type)
      %Ecto.Changeset{data: %OfferType{}}

  """
  def change_offer_type(%OfferType{} = offer_type, attrs \\ %{}) do
    OfferType.changeset(offer_type, attrs)
  end

  alias Parzival.Companies.OfferTime

  @doc """
  Returns the list of offer_times.

  ## Examples

      iex> list_offer_times()
      [%OfferTime{}, ...]

  """
  def list_offer_times(params \\ %{})

  def list_offer_times(opts) when is_list(opts) do
    OfferTime
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_offer_times(flop) do
    Flop.validate_and_run(OfferTime, flop, for: OfferTime)
  end

  def list_offer_times(%{} = flop, opts) when is_list(opts) do
    OfferTime
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: OfferTime)
  end

  @doc """
  Gets a single offer_time.

  Raises `Ecto.NoResultsError` if the Offer time does not exist.

  ## Examples

      iex> get_offer_time!(123)
      %OfferTime{}

      iex> get_offer_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_offer_time!(id), do: Repo.get!(OfferTime, id)

  @doc """
  Creates a offer_time.

  ## Examples

      iex> create_offer_time(%{field: value})
      {:ok, %OfferTime{}}

      iex> create_offer_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_offer_time(attrs \\ %{}) do
    %OfferTime{}
    |> OfferTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a offer_time.

  ## Examples

      iex> update_offer_time(offer_time, %{field: new_value})
      {:ok, %OfferTime{}}

      iex> update_offer_time(offer_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_offer_time(%OfferTime{} = offer_time, attrs) do
    offer_time
    |> OfferTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a offer_time.

  ## Examples

      iex> delete_offer_time(offer_time)
      {:ok, %OfferTime{}}

      iex> delete_offer_time(offer_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_offer_time(%OfferTime{} = offer_time) do
    Repo.delete(offer_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking offer_time changes.

  ## Examples

      iex> change_offer_time(offer_time)
      %Ecto.Changeset{data: %OfferTime{}}

  """
  def change_offer_time(%OfferTime{} = offer_time, attrs \\ %{}) do
    OfferTime.changeset(offer_time, attrs)
  end

  alias Parzival.Companies.Application

  @doc """
  Returns the list of applications.

  ## Examples

      iex> list_applications()
      [%Application{}, ...]

  """
  def list_applications(params \\ %{})

  def list_applications(opts) when is_list(opts) do
    Application
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_applications(flop) do
    Flop.validate_and_run(Application, flop, for: Application)
  end

  def list_applications(%{} = flop, opts) when is_list(opts) do
    Application
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Application)
  end

  @doc """
  Gets a single application.

  Raises `Ecto.NoResultsError` if the Application does not exist.

  ## Examples

      iex> get_application!(123)
      %Application{}

      iex> get_application!(456)
      ** (Ecto.NoResultsError)

  """
  def get_application!(id), do: Repo.get!(Application, id)

  @doc """
  Creates a application.

  ## Examples

      iex> create_application(%{field: value})
      {:ok, %Application{}}

      iex> create_application(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_application(attrs \\ %{}) do
    %Application{}
    |> Application.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a application.

  ## Examples

      iex> update_application(application, %{field: new_value})
      {:ok, %Application{}}

      iex> update_application(application, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_application(%Application{} = application, attrs) do
    application
    |> Application.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a application.

  ## Examples

      iex> delete_application(application)
      {:ok, %Application{}}

      iex> delete_application(application)
      {:error, %Ecto.Changeset{}}

  """
  def delete_application(%Application{} = application) do
    Repo.delete(application)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking application changes.

  ## Examples

      iex> change_application(application)
      %Ecto.Changeset{data: %Application{}}

  """
  def change_application(%Application{} = application, attrs \\ %{}) do
    Application.changeset(application, attrs)
  end

  def is_user_applied?(%Offer{} = offer, %User{} = user) do
    Repo.one(
      from a in Application,
        where: a.user_id == ^user.id and a.offer_id == ^offer.id
    )
  end

  def create_offer_application(%Offer{} = offer, %User{} = user) do
    %Application{}
    |> Application.changeset(%{
      offer_id: offer.id,
      user_id: user.id
    })
    |> Repo.insert()
    |> broadcast(:new_application)
  end

  def delete_offer_application(%Offer{} = offer, %User{} = user) do
    Repo.delete_all(
      from a in Application,
        where: a.user_id == ^user.id and a.offer_id == ^offer.id
    )
    |> broadcast(:deleted_application)
  end

  def get_total_applied(%Offer{} = offer) do
    Application
    |> where(offer_id: ^offer.id)
    |> Repo.aggregate(:count, :id)
  end

  def subscribe(topic) when topic in ["new_application", "deleted_application"] do
    Phoenix.PubSub.subscribe(Parzival.PubSub, topic)
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, %Application{} = application}, event)
       when event in [:new_application] do
    Phoenix.PubSub.broadcast!(Parzival.PubSub, "new_application", {event, application})
    {:ok, application}
  end

  defp broadcast({number, nil}, event)
       when event in [:deleted_application] do
    Phoenix.PubSub.broadcast!(Parzival.PubSub, "deleted_application", {event, nil})
    {number, nil}
  end
end
