defmodule Parzival.Companies do
  @moduledoc """
  The Companies context.
  """
  use Parzival.Context

  alias Parzival.Accounts.User
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
    |> join(:left, [o], p in assoc(o, :level), as: :level)
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Company)
  end

  def get_company_level(company_id) do
    company = get_company!(company_id) |> Repo.preload(:level)

    company.level.name
  end

  def get_company_connections(company_id) do
    company = get_company!(company_id) |> Repo.preload(:connections)

    company
    |> Repo.preload(:connections)
    |> Repo.one!()
    |> Map.get(:connections)
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
  def get_company!(id, opts \\ []) do
    Company
    |> apply_filters(opts)
    |> Repo.get!(id)
  end

  def get_company_by_name(name) do
    Company
    |> where(name: ^name)
    |> Repo.one!()
  end

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}, after_save \\ &{:ok, &1}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
    |> after_save(after_save)
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs, after_save \\ &{:ok, &1}) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
    |> after_save(after_save)
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
    company
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.foreign_key_constraint(:error,
      name: :users_company_id_fkey,
      message: "This company can't be deleted, because recruiters are associated to it!"
    )
    |> Ecto.Changeset.foreign_key_constraint(:error,
      name: :offers_company_id_fkey,
      message: "This company can't be deleted, because job offers are associated to it!"
    )
    |> Repo.delete()
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

  def update_company_picture(%Company{} = company, attrs) do
    company
    |> Company.picture_changeset(attrs)
    |> Repo.update()
  end

  alias Parzival.Companies.Level

  @doc """
  Returns the list of levels.

  ## Examples

      iex> list_levels()
      [%Level{}, ...]

  """
  def list_levels(params \\ %{})

  def list_levels(opts) when is_list(opts) do
    Level
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_levels(flop) do
    Flop.validate_and_run(Level, flop, for: Level)
  end

  def list_levels(%{} = flop, opts) when is_list(opts) do
    Level
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Level)
  end

  @doc """
  Gets a single level.

  Raises `Ecto.NoResultsError` if the Level does not exist.

  ## Examples

      iex> get_level!(123)
      %Level{}

      iex> get_level!(456)
      ** (Ecto.NoResultsError)

  """
  def get_level!(id), do: Repo.get!(Level, id)

  @doc """
  Creates a level.

  ## Examples

      iex> create_level(%{field: value})
      {:ok, %Level{}}

      iex> create_level(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_level(attrs \\ %{}) do
    %Level{}
    |> Level.changeset(attrs)
    |> Ecto.Changeset.put_change(:sort_order, get_next_level_sort_order(Level))
    |> Repo.insert()
  end

  defp get_next_level_sort_order(query) do
    existing_sort_order = Repo.aggregate(from(q in query), :max, :sort_order) || 0
    existing_sort_order + 1
  end

  @doc """
  Updates a level.

  ## Examples

      iex> update_level(level, %{field: new_value})
      {:ok, %Level{}}

      iex> update_level(level, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_level(%Level{} = level, attrs) do
    level
    |> Level.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a level.

  ## Examples

      iex> delete_level(level)
      {:ok, %Level{}}

      iex> delete_level(level)
      {:error, %Ecto.Changeset{}}

  """
  def delete_level(%Level{} = level) do
    Repo.delete(level)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking level changes.

  ## Examples

      iex> change_level(level)
      %Ecto.Changeset{data: %Level{}}

  """
  def change_level(%Level{} = level, attrs \\ %{}) do
    Level.changeset(level, attrs)
  end

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
    offer
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.foreign_key_constraint(:applications,
      name: :applications_offer_id_fkey,
      message: "This offer can't be deleted, because users have applied to it!"
    )
    |> Repo.delete()
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

  alias Parzival.Companies.Connection

  @doc """
  Returns the list of connections.

  ## Examples

      iex> list_connections()
      [%Connection{}, ...]

  """
  def list_connections(params \\ %{})

  def list_connections(opts) when is_list(opts) do
    Connection
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_connections(flop) do
    Flop.validate_and_run(Connection, flop, for: Connection)
  end

  def list_connections(%{} = flop, opts) when is_list(opts) do
    Connection
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Connection)
  end

  @doc """
  Gets a single connection.

  Raises `Ecto.NoResultsError` if the Connection does not exist.

  ## Examples

      iex> get_connection!(123)
      %Connection{}

      iex> get_connection!(456)
      ** (Ecto.NoResultsError)

  """
  def get_connection!(id), do: Repo.get!(Connection, id)

  @doc """
  Creates a connection.

  ## Examples

      iex> create_connection(%{field: value})
      {:ok, %Connection{}}

      iex> create_connection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_connection(%Company{} = company, %User{} = user) do
    %Connection{}
    |> Connection.changeset(%{company_id: company.id, user_id: user.id})
    |> Repo.insert()
  end

  @doc """
  Updates a connection.

  ## Examples

      iex> update_connection(connection, %{field: new_value})
      {:ok, %Connection{}}

      iex> update_connection(connection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_connection(%Connection{} = connection, attrs) do
    connection
    |> Connection.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a connection.

  ## Examples

      iex> delete_connection(connection)
      {:ok, %Connection{}}

      iex> delete_connection(connection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_connection(%Connection{} = connection) do
    Repo.delete(connection)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking connection changes.

  ## Examples

      iex> change_connection(connection)
      %Ecto.Changeset{data: %Connection{}}

  """
  def change_connection(%Connection{} = connection, attrs \\ %{}) do
    Connection.changeset(connection, attrs)
  end
end
