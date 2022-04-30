defmodule Parzival.Tools.Faq do
  @moduledoc """
  A faq.
  """
  use Parzival.Schema

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
