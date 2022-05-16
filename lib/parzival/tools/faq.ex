defmodule Parzival.Tools.Faq do
  @moduledoc """
  A faq.
  """
  use Parzival.Schema

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [:inserted_at],
    compound_fields: [],
    default_order_by: [:inserted_at],
    default_order_directions: [:asc]
  }

  schema "faqs" do
    field :answer, :string
    field :question, :string

    timestamps()
  end

  @doc false
  def changeset(faq, attrs) do
    faq
    |> cast(attrs, [:question, :answer])
    |> validate_required([:question, :answer])
  end
end
