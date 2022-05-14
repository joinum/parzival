defmodule Parzival.Accounts.User do
  @moduledoc """
  A user of the application capable of authenticating.
  """
  use Parzival.Schema

  alias Parzival.Gamification.Curriculum
  alias Parzival.Store.Order

  @roles ~w(admin staff attendee company)a
  @cycles ~w(Bachelors Masters Phd)a

  @required_fields ~w(email password name role balance)a

  @optional_fields [
    :course,
    :cycle,
    :cellphone,
    :website,
    :linkedin,
    :github,
    :twitter
  ]

  @derive {
    Flop.Schema,
    filterable: [:role, :search],
    sortable: [:name, :email],
    compound_fields: [search: [:email, :name]],
    default_order_by: [:name, :email],
    default_order_directions: [:asc, :asc]
  }

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :naive_datetime

    field :balance, :integer, default: 0

    field :name, :string
    field :role, Ecto.Enum, values: @roles
    field :course, :string
    field :cycle, Ecto.Enum, values: @cycles
    field :cellphone, :string
    field :website, :string
    field :linkedin, :string
    field :github, :string
    field :twitter, :string

    has_one :curriculum, Curriculum

    has_many :orders, Order

    timestamps()
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_email()
    |> validate_password(opts)
  end

  def changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [
      :name,
      :email,
      :role
    ])
    |> validate_required([:name])
    |> validate_email()
    |> generate_random_password(opts)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_email_address(:email)
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Parzival.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp validate_balance(changeset) do
    changeset
    |> validate_required([:balance])
    |> validate_number(:balance, greater_than_or_equal_to: 0)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  defp generate_random_password(changeset, opts) do
    generate_password? = Keyword.get(opts, :generate_password, true)

    if generate_password? do
      changeset
      |> put_change(:password, Base.encode64(:crypto.strong_rand_bytes(32)))
      |> maybe_hash_password(hash_password: true)
    else
      changeset
      |> put_change(:hashed_password, Base.encode64(:crypto.strong_rand_bytes(32)))
    end
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  def balance_changeset(user, attrs) do
    user
    |> cast(attrs, [:balance])
    |> validate_balance()
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Parzival.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end
end
