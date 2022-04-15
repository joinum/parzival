defmodule Parzival.Announcements.Announcement do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(title content)a
  @optional_fields []
  schema "announcements" do
    field :content, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(announcement, attrs) do
    announcement
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
