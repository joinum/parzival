defmodule Parzival.Tools.Faqs do
  use Ecto.Schema
  import Ecto.Changeset

  schema "faqs" do
    field :answer, :string
    field :question, :string

    timestamps()
  end

  @doc false
  def changeset(faqs, attrs) do
    faqs
    |> cast(attrs, [:question, :answer])
    |> validate_required([:question, :answer])
  end
end
