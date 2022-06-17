defmodule Parzival.Tools.Post do
  @moduledoc """
  A post.
  """
  use Parzival.Schema

  alias Parzival.Accounts
  alias Parzival.Companies

  @required_fields ~w(text author_id)a
  @optional_fields [:offer_id]

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [:inserted_at],
    compound_fields: [search: []],
    default_order_by: [:inserted_at],
    default_order_directions: [:desc]
  }

  schema "posts" do
    field :text, :string

    belongs_to :author, Accounts.User
    belongs_to :offer, Companies.Offer

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
