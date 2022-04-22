defmodule Parzival.Store.Prize do
  use Ecto.Schema
  import Ecto.Changeset

  schema "prizes" do
    field :quantity, :integer
    field :redeemed, :integer

    timestamps()
  end

  @doc false
  def changeset(prize, attrs) do
    prize
    |> cast(attrs, [:quantity, :redeemed])
    |> validate_required([:quantity, :redeemed])
  end
end
