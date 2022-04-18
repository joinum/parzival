defmodule Parzival.Tools.Announcement do
  use Ecto.Schema
  import Ecto.Changeset

  alias Parzival.Accounts

  @required_fields ~w(title text)a
  @optional_fields []
  schema "announcements" do
    field :title, :string
    field :text, :string

    # belongs_to :author, Accounts.User

    timestamps()
  end

  @doc false
  def changeset(announcement, attrs) do
    announcement
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
