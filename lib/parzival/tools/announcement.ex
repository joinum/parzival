defmodule Parzival.Tools.Announcement do
  @moduledoc """
  A announcement.
  """
  use Parzival.Schema

  alias Parzival.Accounts

  @required_fields ~w(title text author_id)a
  @optional_fields []

  @derive {
    Flop.Schema,
    filterable: [:search],
    sortable: [:inserted_at, :title],
    compound_fields: [search: [:title]],
    default_order_by: [:inserted_at, :title],
    default_order_directions: [:desc]
  }

  schema "announcements" do
    field :title, :string
    field :text, :string

    belongs_to :author, Accounts.User

    timestamps()
  end

  @doc false
  def changeset(announcement, attrs) do
    announcement
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
